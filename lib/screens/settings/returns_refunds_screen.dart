import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/buttons/buttons.dart';

/// Model for return request
class ReturnRequest {
  final String id;
  final String orderId;
  final String productName;
  final String productImage;
  final double refundAmount;
  final String status;
  final DateTime requestDate;
  final String reason;

  const ReturnRequest({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.productImage,
    required this.refundAmount,
    required this.status,
    required this.requestDate,
    required this.reason,
  });
}

/// Provider for return requests
final returnRequestsProvider = Provider<List<ReturnRequest>>((ref) {
  return [
    ReturnRequest(
      id: 'RET001',
      orderId: 'ORD-2024-001',
      productName: 'Nike Air Max 270',
      productImage:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      refundAmount: 159.99,
      status: 'Processing',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      reason: 'Wrong size',
    ),
    ReturnRequest(
      id: 'RET002',
      orderId: 'ORD-2024-002',
      productName: 'Wireless Headphones',
      productImage:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
      refundAmount: 89.99,
      status: 'Approved',
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      reason: 'Defective product',
    ),
    ReturnRequest(
      id: 'RET003',
      orderId: 'ORD-2024-003',
      productName: 'Classic T-Shirt',
      productImage:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=200',
      refundAmount: 29.99,
      status: 'Refunded',
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
      reason: 'Changed mind',
    ),
  ];
});

/// Returns & Refunds screen
class ReturnsRefundsScreen extends ConsumerWidget {
  const ReturnsRefundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returns = ref.watch(returnRequestsProvider);

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
          'Returns & Refunds',
          style: AppTypography.h4.copyWith(color: AppColors.foreground),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: _buildInfoCard(),
            ),

            // Quick Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.add_circle_outline,
                      label: 'New Return',
                      onTap: () => _showNewReturnSheet(context),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.policy_outlined,
                      label: 'Return Policy',
                      onTap: () => _showReturnPolicySheet(context),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildQuickAction(
                      context,
                      icon: Icons.help_outline,
                      label: 'Help',
                      onTap: () => _showHelpSheet(context),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Return Requests
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'Your Returns',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.foreground,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),

            if (returns.isEmpty)
              _buildEmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: returns.length,
                itemBuilder: (context, index) {
                  return _buildReturnCard(context, returns[index]);
                },
              ),

            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.assignment_return,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Easy Returns',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '30-day free returns on all orders',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.foreground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReturnCard(BuildContext context, ReturnRequest request) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Image.network(
                    request.productImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.muted,
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.productName,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.foreground,
                        ),
                      ),
                      Text(
                        'Order: ${request.orderId}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          _buildStatusChip(request.status),
                          const Spacer(),
                          Text(
                            '\$${request.refundAmount.toStringAsFixed(2)}',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: () => _showReturnDetails(context, request),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'processing':
        color = AppColors.warning;
        break;
      case 'approved':
        color = AppColors.accent;
        break;
      case 'refunded':
        color = AppColors.success;
        break;
      case 'rejected':
        color = AppColors.destructive;
        break;
      default:
        color = AppColors.foregroundSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        status,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_return_outlined,
              size: 64,
              color: AppColors.foregroundSecondary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'No Returns Yet',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.foreground,
                fontSize: 18,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'You haven\'t initiated any returns.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewReturnSheet(BuildContext context) {
    String? selectedReason;
    final reasons = [
      'Wrong size',
      'Wrong item delivered',
      'Defective product',
      'Changed mind',
      'Product not as described',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Request a Return',
                style: AppTypography.h4.copyWith(color: AppColors.foreground),
              ),
              SizedBox(height: AppSpacing.md),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Order ID',
                  hintText: 'Enter your order ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Reason for return',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.foreground,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: reasons.map((reason) {
                  final isSelected = selectedReason == reason;
                  return ChoiceChip(
                    label: Text(reason),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => selectedReason = selected ? reason : null);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.foreground,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: AppSpacing.md),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Additional Comments (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: 'Submit Return Request',
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 48,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Return Requested!',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Your return request has been submitted. We\'ll review it and get back to you within 24 hours.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  void _showReturnDetails(BuildContext context, ReturnRequest request) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Return Details',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.md),
            _buildDetailRow('Return ID', request.id),
            _buildDetailRow('Order ID', request.orderId),
            _buildDetailRow('Product', request.productName),
            _buildDetailRow('Reason', request.reason),
            _buildDetailRow(
              'Request Date',
              '${request.requestDate.day}/${request.requestDate.month}/${request.requestDate.year}',
            ),
            _buildDetailRow(
              'Refund Amount',
              '\$${request.refundAmount.toStringAsFixed(2)}',
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.foregroundSecondary,
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            _buildStatusTimeline(request.status),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.foregroundSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final steps = ['Requested', 'Processing', 'Approved', 'Refunded'];
    int currentIndex;
    switch (currentStatus.toLowerCase()) {
      case 'processing':
        currentIndex = 1;
        break;
      case 'approved':
        currentIndex = 2;
        break;
      case 'refunded':
        currentIndex = 3;
        break;
      default:
        currentIndex = 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.foreground,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index <= currentIndex;
            final isLast = index == steps.length - 1;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success : AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : Text(
                              '${index + 1}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.foregroundSecondary,
                              ),
                            ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentIndex
                            ? AppColors.success
                            : AppColors.muted,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: steps.map((step) {
            return Expanded(
              child: Text(
                step,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.foregroundSecondary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showReturnPolicySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Return Policy',
                style: AppTypography.h4.copyWith(color: AppColors.foreground),
              ),
              SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildPolicySection(
                      'Return Window',
                      'You have 30 days from the delivery date to return most items for a full refund.',
                    ),
                    _buildPolicySection(
                      'Condition Requirements',
                      'Items must be unused, in original packaging, and with all tags attached.',
                    ),
                    _buildPolicySection(
                      'Non-Returnable Items',
                      'Personal care items, underwear, swimwear, and customized products cannot be returned.',
                    ),
                    _buildPolicySection(
                      'Refund Process',
                      'Refunds are processed within 5-7 business days after we receive your return.',
                    ),
                    _buildPolicySection(
                      'Return Shipping',
                      'Free return shipping is available for all orders. Use our prepaid label or drop off at any partner location.',
                    ),
                    _buildPolicySection(
                      'Exchanges',
                      'Need a different size or color? Request an exchange instead of a return for faster processing.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.foregroundSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          const Divider(),
        ],
      ),
    );
  }

  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Need Help?',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.md),
            _buildHelpItem(
              Icons.chat_bubble_outline,
              'Live Chat',
              'Chat with our support team',
              () => Navigator.pop(context),
            ),
            const Divider(),
            _buildHelpItem(
              Icons.email_outlined,
              'Email Support',
              'returns@example.com',
              () => Navigator.pop(context),
            ),
            const Divider(),
            _buildHelpItem(
              Icons.phone_outlined,
              'Call Us',
              '1-800-RETURNS',
              () => Navigator.pop(context),
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTypography.labelLarge),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.foregroundSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
