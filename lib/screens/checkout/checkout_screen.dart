import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/navigation/app_routes.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/common/app_back_button.dart';
import '../../widgets/buttons/buttons.dart';
import '../../providers/providers.dart';
import '../../models/payment_method.dart';
import '../../models/shipping_address.dart';
import '../../utils/validators.dart';
import '../orders/order_confirmation_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _shippingFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  int _currentStep = 0;
  bool _acceptTerms = false;
  bool _isProcessing = false;
  String _selectedShippingMethod = 'standard';
  String? _selectedPaymentMethodId;
  bool _expandAddressSection = true;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
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
            color: AppColors.border.withValues(alpha: 0.3),
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
    return Form(
      key: _shippingFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: AppColors.border.withValues(alpha: 0.05),
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
                    _expandAddressSection
                        ? Icons.expand_less
                        : Icons.expand_more,
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
                    controller: _nameController,
                    autofillHints: const [AutofillHints.name],
                    textInputAction: TextInputAction.next,
                    validator: (value) => AppValidators.requiredText(
                      value,
                      fieldName: 'Full name',
                      minimumLength: 2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),

                  _buildTextField(
                    label: 'Email Address',
                    hint: 'your.email@example.com',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.email,
                  ),
                  SizedBox(height: AppSpacing.md),

                  _buildTextField(
                    label: 'Street Address',
                    hint: 'Enter your street address',
                    icon: Icons.home_outlined,
                    controller: _streetController,
                    autofillHints: const [AutofillHints.streetAddressLine1],
                    textInputAction: TextInputAction.next,
                    validator: (value) => AppValidators.requiredText(
                      value,
                      fieldName: 'Street address',
                      minimumLength: 4,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'City',
                          hint: 'City',
                          icon: Icons.location_city_outlined,
                          controller: _cityController,
                          autofillHints: const [AutofillHints.addressCity],
                          textInputAction: TextInputAction.next,
                          validator: (value) => AppValidators.requiredText(
                            value,
                            fieldName: 'City',
                            minimumLength: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildTextField(
                          label: 'State/Region',
                          hint: 'State or region',
                          controller: _stateController,
                          autofillHints: const [AutofillHints.addressState],
                          textInputAction: TextInputAction.next,
                          validator: (value) => AppValidators.requiredText(
                            value,
                            fieldName: 'State or region',
                            minimumLength: 2,
                          ),
                        ),
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
                          controller: _postalCodeController,
                          autofillHints: const [AutofillHints.postalCode],
                          textInputAction: TextInputAction.next,
                          validator: (value) => AppValidators.requiredText(
                            value,
                            fieldName: 'Postal code',
                            minimumLength: 3,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildTextField(
                          label: 'Phone',
                          hint: '+1 (555) 000-0000',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.phone,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.md),
                  _buildTextField(
                    label: 'Country',
                    hint: 'Enter your country',
                    icon: Icons.public_outlined,
                    controller: _countryController,
                    autofillHints: const [AutofillHints.countryName],
                    textInputAction: TextInputAction.done,
                    validator: (value) => AppValidators.requiredText(
                      value,
                      fieldName: 'Country',
                      minimumLength: 2,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),
                  _buildInfoBanner(
                    'Review your address carefully to prevent delivery delays.',
                    Icons.info_outline,
                  ),
                ],
              ),
            ),
        ],
      ),
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
            color: AppColors.border.withValues(alpha: 0.05),
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

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title, \$${price.toStringAsFixed(2)}',
      child: InkWell(
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
                ? AppColors.primary.withValues(alpha: 0.05)
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
                      : AppColors.border.withValues(alpha: 0.3),
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
                            color: AppColors.primary.withValues(alpha: 0.1),
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
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.foregroundSecondary,
              ),
            ],
          ),
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
            color: AppColors.border.withValues(alpha: 0.05),
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
              if (paymentMethods.isEmpty)
                _buildInfoBanner(
                  'No payment method is available. Add one before placing your order.',
                  Icons.credit_card_off_outlined,
                )
              else
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
                  Navigator.of(context).pushNamed(AppRoutes.paymentMethods);
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
                  color: AppColors.primary.withValues(alpha: 0.05),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
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
    final isSelected =
        _selectedPaymentMethodId == method.id ||
        (_selectedPaymentMethodId == null && method.isDefault);

    return Semantics(
      selected: isSelected,
      button: true,
      label: '${method.name}, $maskedCard',
      child: InkWell(
        onTap: () => setState(() => _selectedPaymentMethodId = method.id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.border.withValues(alpha: 0.3),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
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
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.foregroundSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(dynamic cartState) {
    final subtotal = cartState.subtotal ?? 0.0;
    final shippingCost = 5.99;
    final tax = subtotal * 0.1;
    final total = subtotal + shippingCost + tax;

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

          SizedBox(height: AppSpacing.md),

          // Total with border
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withValues(alpha: 0.05),
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
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    Iterable<String>? autofillHints,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
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
        color: AppColors.border.withValues(alpha: 0.1),
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
                  onPressed: _isProcessing ? null : _handlePrimaryAction,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePrimaryAction() async {
    if (_currentStep == 0) {
      final isValid = _shippingFormKey.currentState?.validate() ?? false;
      if (!isValid) {
        setState(() => _expandAddressSection = true);
        return;
      }
      setState(() => _currentStep = 1);
      return;
    }

    if (_currentStep == 1) {
      final methods = ref.read(paymentMethodsProvider);
      if (_selectedPaymentMethodId == null && methods.isNotEmpty) {
        final defaultMethods = methods.where((method) => method.isDefault);
        _selectedPaymentMethodId = defaultMethods.isNotEmpty
            ? defaultMethods.first.id
            : methods.first.id;
      }
      setState(() => _currentStep = 2);
      return;
    }

    if (ref.read(cartProvider).items.isEmpty) {
      _showError('Your cart is empty. Add an item before checking out.');
      return;
    }
    if (_selectedPaymentMethod() == null) {
      _showError('Select a payment method before placing your order.');
      return;
    }
    if (!_acceptTerms) {
      _showError('Accept the terms and return policy to continue.');
      return;
    }

    await _processOrder();
  }

  PaymentMethod? _selectedPaymentMethod() {
    final methods = ref.read(paymentMethodsProvider);
    if (methods.isEmpty) return null;
    if (_selectedPaymentMethodId != null) {
      for (final method in methods) {
        if (method.id == _selectedPaymentMethodId) return method;
      }
    }
    for (final method in methods) {
      if (method.isDefault) return method;
    }
    return methods.first;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _processOrder() async {
    setState(() => _isProcessing = true);

    final cartState = ref.read(cartProvider);
    final paymentMethod = _selectedPaymentMethod()!;
    final shippingAddress = ShippingAddress(
      id: 'checkout',
      name: _nameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final subtotal = cartState.subtotal;
    final shippingCost = _selectedShippingMethod == 'express'
        ? 15.99
        : _selectedShippingMethod == 'overnight'
        ? 29.99
        : 5.99;
    final tax = subtotal * 0.1;

    try {
      final order = await ref
          .read(orderProvider.notifier)
          .createOrder(
            items: cartState.items,
            shippingAddress: shippingAddress,
            paymentMethod:
                '${paymentMethod.name} •••• ${paymentMethod.cardNumber ?? ''}',
            subtotal: subtotal,
            shippingCost: shippingCost,
            tax: tax,
          );

      await ref.read(cartProvider.notifier).clearCart();
      if (!mounted) return;
      setState(() => _isProcessing = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(order: order),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      _showError('We could not place your order. Please try again.');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
