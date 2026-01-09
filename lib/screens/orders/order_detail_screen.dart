import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/theme/colors.dart';
import '../../models/order.dart';
import '../../providers/notifiers/order_notifier.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(singleOrderProvider(orderId));

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          order.orderNumber,
          style: const TextStyle(
            color: AppColors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (order.canCancel)
            TextButton(
              onPressed: () => _showCancelDialog(context, ref, order),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            _buildStatusCard(order),
            const SizedBox(height: 20),

            // Tracking timeline
            if (order.timeline.isNotEmpty) ...[
              const Text(
                'Order Timeline',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildTimeline(order.timeline),
              const SizedBox(height: 20),
            ],

            // Tracking info
            if (order.trackingNumber != null) ...[
              _buildTrackingCard(context, order),
              const SizedBox(height: 20),
            ],

            // Order items
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildOrderItems(order),
            const SizedBox(height: 20),

            // Shipping address
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildAddressCard(order),
            const SizedBox(height: 20),

            // Payment summary
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildPaymentSummary(order),
            const SizedBox(height: 32),

            // Actions
            _buildActions(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Order order) {
    IconData statusIcon;
    Color statusColor;

    switch (order.status) {
      case OrderStatus.pending:
        statusIcon = Icons.hourglass_empty;
        statusColor = AppColors.warning;
        break;
      case OrderStatus.confirmed:
        statusIcon = Icons.check_circle_outline;
        statusColor = AppColors.accent;
        break;
      case OrderStatus.processing:
        statusIcon = Icons.inventory_2_outlined;
        statusColor = AppColors.accent;
        break;
      case OrderStatus.shipped:
        statusIcon = Icons.local_shipping_outlined;
        statusColor = AppColors.accent;
        break;
      case OrderStatus.outForDelivery:
        statusIcon = Icons.directions_bike;
        statusColor = AppColors.accent;
        break;
      case OrderStatus.delivered:
        statusIcon = Icons.check_circle;
        statusColor = AppColors.success;
        break;
      case OrderStatus.cancelled:
        statusIcon = Icons.cancel;
        statusColor = AppColors.error;
        break;
      case OrderStatus.returned:
        statusIcon = Icons.assignment_return;
        statusColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.statusDisplayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (order.estimatedDelivery != null &&
                    order.status != OrderStatus.delivered &&
                    order.status != OrderStatus.cancelled)
                  Text(
                    'Estimated: ${DateFormat('MMM dd, yyyy').format(order.estimatedDelivery!)}',
                    style: const TextStyle(color: AppColors.foregroundMuted),
                  ),
                if (order.deliveredAt != null)
                  Text(
                    'Delivered: ${DateFormat('MMM dd, yyyy').format(order.deliveredAt!)}',
                    style: const TextStyle(color: AppColors.foregroundMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<OrderTimelineEvent> timeline) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: timeline.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          final isLast = index == timeline.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: event.isCompleted
                          ? AppColors.success
                          : AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                    child: event.isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: event.isCompleted
                          ? AppColors.success
                          : AppColors.muted,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: event.isCompleted
                            ? AppColors.foreground
                            : AppColors.foregroundMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: event.isCompleted
                            ? AppColors.foregroundSecondary
                            : AppColors.foregroundMuted,
                      ),
                    ),
                    if (event.isCompleted) ...[
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM dd, hh:mm a').format(event.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.foregroundMuted,
                        ),
                      ),
                    ],
                    SizedBox(height: isLast ? 0 : 16),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrackingCard(BuildContext context, Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.carrierName ?? 'Carrier',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  order.trackingNumber!,
                  style: const TextStyle(
                    color: AppColors.foregroundMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: order.trackingNumber!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tracking number copied'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(Order order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: order.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == order.items.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.foregroundMuted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.selectedColor} • Size ${item.selectedSize}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.foregroundMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.foregroundMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddressCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.shippingAddress.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  order.shippingAddress.fullAddress,
                  style: const TextStyle(
                    color: AppColors.foregroundMuted,
                    fontSize: 13,
                  ),
                ),
                if (order.shippingAddress.phone != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    order.shippingAddress.phone!,
                    style: const TextStyle(
                      color: AppColors.foregroundMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            '\$${order.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Shipping',
            order.shippingCost == 0
                ? 'Free'
                : '\$${order.shippingCost.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
          if (order.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount${order.promoCode != null ? ' (${order.promoCode})' : ''}',
              '-\$${order.discount.toStringAsFixed(2)}',
              valueColor: AppColors.success,
            ),
          ],
          const SizedBox(height: 8),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Total',
            '\$${order.total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.credit_card,
                size: 18,
                color: AppColors.foregroundMuted,
              ),
              const SizedBox(width: 8),
              Text(
                'Paid with ${order.paymentMethod}',
                style: const TextStyle(
                  color: AppColors.foregroundMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: isBold
                ? AppColors.foreground
                : AppColors.foregroundSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? AppColors.foreground,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (order.status == OrderStatus.delivered) ...[
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to write review
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Write review coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primaryForeground,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Write a Review'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              // TODO: Reorder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reorder coming soon!')),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Buy Again'),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Contact support
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support contact coming soon!')),
              );
            },
            icon: const Icon(Icons.headset_mic_outlined),
            label: const Text('Need Help?'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () {
              ref.read(orderProvider.notifier).cancelOrder(order.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order cancelled successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}
