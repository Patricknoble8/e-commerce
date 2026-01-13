import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/buttons/buttons.dart';
import '../../providers/providers.dart';
import '../../models/shipping_address.dart';
import '../orders/order_confirmation_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  bool _acceptTerms = false;
  bool _isProcessing = false;
  String _selectedShippingMethod = 'standard';
  bool _expandAddressSection = true;
  bool _expandPromoSection = false;
  final _promoController = TextEditingController();
  String? _appliedPromo;
  double _discountAmount = 0;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          Expanded(
            child: isMobile
                ? _buildMobileLayout(cartState)
                : _buildDesktopLayout(cartState),
          ),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(dynamic cartState) {
    return Row(
      children: [
        // Left column - Checkout form
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentStep == 0) ...[
                    _buildShippingAddressSection(),
                  ] else if (_currentStep == 1) ...[
                    _buildShippingMethodSection(),
                  ] else if (_currentStep == 2) ...[
                    _buildPaymentMethodSection(cartState),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Right column - Order Summary (Sticky)
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.border.withOpacity(0.3),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: _buildOrderSummaryCard(cartState),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(dynamic cartState) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStep == 0) ...[
              _buildShippingAddressSection(),
            ] else if (_currentStep == 1) ...[
              _buildShippingMethodSection(),
            ] else if (_currentStep == 2) ...[
              _buildPaymentMethodSection(cartState),
            ],
            SizedBox(height: AppSpacing.lg),
            _buildOrderSummaryCard(cartState),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ['Shipping', 'Method', 'Payment'];
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _buildStepIndicator(steps[stepIndex], stepIndex);
          } else {
            return Expanded(
              child: Container(
                height: 2,
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                color: _currentStep > index ~/ 2
                    ? AppColors.primary
                    : AppColors.border,
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildStepIndicator(String label, int step) {
    final isActive = step <= _currentStep;
    final isCompleted = step < _currentStep;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${step + 1}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isActive
                ? AppColors.foreground
                : AppColors.foregroundSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Header
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: AppColors.border.withOpacity(0.05),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Shipping Address',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _expandAddressSection ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.foregroundSecondary,
                ),
                onPressed: () {
                  setState(
                    () => _expandAddressSection = !_expandAddressSection,
                  );
                },
              ),
            ],
          ),
        ),

        if (_expandAddressSection)
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: AppSpacing.md),

                _buildTextField(
                  label: 'Email Address',
                  hint: 'your.email@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppSpacing.md),

                _buildTextField(
                  label: 'Street Address',
                  hint: 'Enter your street address',
                  icon: Icons.home_outlined,
                ),
                SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'City',
                        hint: 'City',
                        icon: Icons.location_city_outlined,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildTextField(label: 'State', hint: 'State'),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'ZIP Code',
                        hint: 'Enter ZIP code',
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildTextField(
                        label: 'Phone',
                        hint: '+1 (555) 000-0000',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),
                _buildInfoBanner(
                  'Measure your address is correct.',
                  Icons.info_outline,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildShippingMethodSection() {
    final shippingMethods = [
      {
        'id': 'standard',
        'title': 'Standard Shipping',
        'description': 'Delivery in 5-7 business days',
        'price': 5.99,
        'icon': Icons.local_shipping_outlined,
        'days': 5,
      },
      {
        'id': 'express',
        'title': 'Express Shipping',
        'description': 'Delivery in 2-3 business days',
        'price': 15.99,
        'icon': Icons.flight_takeoff_outlined,
        'days': 2,
      },
      {
        'id': 'overnight',
        'title': 'Overnight Shipping',
        'description': 'Delivery next business day',
        'price': 29.99,
        'icon': Icons.local_fire_department_outlined,
        'days': 1,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: AppColors.border.withOpacity(0.05),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                'Shipping Method',
                style: AppTypography.h4.copyWith(color: AppColors.foreground),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: Column(
            children: List.generate(shippingMethods.length, (index) {
              final method = shippingMethods[index];
              final isSelected = _selectedShippingMethod == method['id'];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < shippingMethods.length - 1
                      ? AppSpacing.md
                      : 0,
                ),
                child: _buildShippingMethodCard(
                  title: method['title'] as String,
                  description: method['description'] as String,
                  price: method['price'] as double,
                  icon: method['icon'] as IconData,
                  days: method['days'] as int,
                  isSelected: isSelected,
                  onSelect: () {
                    setState(
                      () => _selectedShippingMethod = method['id'] as String,
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingMethodCard({
    required String title,
    required String description,
    required double price,
    required IconData icon,
    required int days,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    final deliveryDate = DateTime.now().add(Duration(days: days));
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final formattedDate =
        '${months[deliveryDate.month - 1]} ${deliveryDate.day}, ${deliveryDate.year}';

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : AppColors.foregroundSecondary,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.foreground,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.foreground,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.foregroundSecondary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          formattedDate,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppTypography.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Radio<String>(
              value: _selectedShippingMethod,
              groupValue: _selectedShippingMethod,
              onChanged: (value) => onSelect(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(dynamic cartState) {
    final paymentMethods = ref.watch(paymentMethodsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Method Header
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: AppColors.border.withOpacity(0.05),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.credit_card_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                'Payment Method',
                style: AppTypography.h4.copyWith(color: AppColors.foreground),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment method cards
              ...paymentMethods.map(
                (method) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildPaymentCardOption(method),
                ),
              ),

              SizedBox(height: AppSpacing.md),

              // Add payment method button
              OutlinedButton.icon(
                onPressed: () {
                  _showAddPaymentDialog();
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Payment Method'),
              ),

              SizedBox(height: AppSpacing.lg),

              // Terms and conditions
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() => _acceptTerms = value ?? false);
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Return Policy',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.md),

              // Trust badges
              _buildTrustBadges(),

              SizedBox(height: AppSpacing.lg),

              // Support contact
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.headset_mic_outlined, color: AppColors.primary),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.foreground,
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            'Contact our support team at support@ecommerce.com',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.foregroundSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCardOption(dynamic method) {
    final maskedCard = _maskCardNumber(method.cardNumber ?? '');

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                _getPaymentIcon(method.type),
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.name ?? method.type,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  maskedCard,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (method.isDefault)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Default',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          Radio<bool>(
            value: true,
            groupValue: true,
            onChanged: (value) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(dynamic cartState) {
    final subtotal = cartState.subtotal ?? 0.0;
    final shippingCost = 5.99;
    final tax = subtotal * 0.1;
    final total = subtotal + shippingCost + tax - _discountAmount;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.h4.copyWith(color: AppColors.foreground),
          ),
          SizedBox(height: AppSpacing.md),

          // Order items
          ...cartState.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: _buildCompactOrderItem(item),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          Divider(color: AppColors.border, height: 1),

          SizedBox(height: AppSpacing.md),

          // Price breakdown
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          SizedBox(height: AppSpacing.sm),
          _buildSummaryRow('Shipping', '\$${shippingCost.toStringAsFixed(2)}'),
          SizedBox(height: AppSpacing.sm),
          _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),

          if (_appliedPromo != null) ...[
            SizedBox(height: AppSpacing.sm),
            _buildSummaryRow(
              'Discount',
              '-\$${_discountAmount.toStringAsFixed(2)}',
              isBold: true,
              isDiscount: true,
            ),
          ],

          SizedBox(height: AppSpacing.md),

          // Promo code section
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _expandPromoSection
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Promo Code',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.foreground,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() => _expandPromoSection = false);
                                  },
                                  child: Icon(
                                    Icons.expand_less,
                                    color: AppColors.foregroundSecondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.sm),
                            TextField(
                              controller: _promoController,
                              decoration: InputDecoration(
                                hintText: 'Enter promo code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _applyPromoCode();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Apply Code',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() => _expandPromoSection = true);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                _appliedPromo ?? 'Add Promo Code',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: _appliedPromo != null
                                      ? AppColors.primary
                                      : AppColors.foregroundSecondary,
                                  fontWeight: _appliedPromo != null
                                      ? AppTypography.semiBold
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.expand_more,
                            color: AppColors.foregroundSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          SizedBox(height: AppSpacing.md),

          // Total with border
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactOrderItem(dynamic item) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(8),
          ),
          child: item.product?.imageUrl != null
              ? Image.network(item.product!.imageUrl, fit: BoxFit.cover)
              : const SizedBox(),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product?.name ?? 'Product',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foreground,
                  fontWeight: AppTypography.medium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Qty: ${item.quantity}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${(item.product?.price ?? 0 * item.quantity).toStringAsFixed(2)}',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.foreground,
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isDiscount ? Colors.green : AppColors.foregroundSecondary,
            fontWeight: isBold ? AppTypography.semiBold : AppTypography.regular,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: isDiscount ? Colors.green : AppColors.foreground,
            fontWeight: isTotal
                ? AppTypography.bold
                : (isBold ? AppTypography.semiBold : AppTypography.medium),
            fontSize: isTotal ? 16 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.foreground,
            fontWeight: AppTypography.semiBold,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.foregroundSecondary)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner(String message, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBadge(Icons.verified_user_outlined, 'SSL Secure'),
          _buildBadge(Icons.shield_outlined, 'Verified'),
          _buildBadge(Icons.lock_outline, 'Safe Payment'),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.foregroundSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) return '**** **** **** ****';
    final cleanCard = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleanCard.length < 4) return cardNumber;
    return '**** **** **** ${cleanCard.substring(cleanCard.length - 4)}';
  }

  IconData _getPaymentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'paypal':
        return Icons.payment;
      case 'apple_pay':
        return Icons.apple;
      default:
        return Icons.credit_card_outlined;
    }
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a promo code')),
      );
      return;
    }

    // Simulate promo code validation
    if (code.toUpperCase() == 'SAVE10') {
      setState(() {
        _appliedPromo = code.toUpperCase();
        _discountAmount = 10.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo code applied successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid promo code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit/Debit Card'),
              onTap: () {
                Navigator.pop(context);
                _showCardForm();
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('PayPal'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to PayPal...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.apple),
              title: const Text('Apple Pay'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to Apple Pay...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCardForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Card Number'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: const TextField(
                    decoration: InputDecoration(labelText: 'MM/YY'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: const TextField(
                    decoration: InputDecoration(labelText: 'CVC'),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card added successfully!')),
              );
            },
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _currentStep--);
                    },
                    child: const Text('Back'),
                  ),
                ),
              if (_currentStep > 0) SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  text: _currentStep == 2
                      ? (_isProcessing ? 'Processing...' : 'Place Order')
                      : 'Next',
                  onPressed: _currentStep == 2 && _acceptTerms && !_isProcessing
                      ? () {
                          _processOrder();
                        }
                      : null,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processOrder() async {
    setState(() => _isProcessing = true);

    // Create the order
    final cartState = ref.read(cartProvider);
    final defaultAddress = ref.read(defaultAddressProvider);

    // Use default address or create a placeholder
    final shippingAddress =
        defaultAddress ??
        const ShippingAddress(
          id: 'temp',
          name: 'Default',
          street: '123 Main Street',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
        );

    final subtotal = cartState.subtotal;
    final shippingCost = _selectedShippingMethod == 'express'
        ? 15.99
        : _selectedShippingMethod == 'overnight'
        ? 29.99
        : 5.99;
    final tax = subtotal * 0.1;

    // Create the order
    final order = await ref
        .read(orderProvider.notifier)
        .createOrder(
          items: cartState.items,
          shippingAddress: shippingAddress,
          paymentMethod: 'Visa •••• 4532',
          subtotal: subtotal,
          shippingCost: shippingCost,
          tax: tax,
          discount: _discountAmount,
          promoCode: _appliedPromo,
        );

    // Clear the cart
    ref.read(cartProvider.notifier).clearCart();

    setState(() => _isProcessing = false);

    // Navigate to order confirmation
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(order: order),
        ),
      );
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }
}
