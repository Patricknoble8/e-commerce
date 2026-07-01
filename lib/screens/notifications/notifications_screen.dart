import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/spacing.dart';
import '../../config/theme/typography.dart';
import '../../widgets/common/app_back_button.dart';
import '../../models/notification.dart';
import '../../providers/notifiers/notifications_notifier.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AppNotification> _getFilteredNotifications(
    List<AppNotification> notifications,
  ) {
    if (_selectedFilter == 'all') {
      return notifications;
    } else if (_selectedFilter == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications.where((n) => n.type == _selectedFilter).toList();
  }

  Map<String, List<AppNotification>> _groupByDate(
    List<AppNotification> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final grouped = <String, List<AppNotification>>{};

    for (var notification in notifications) {
      final nDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      String key;
      if (nDate == today) {
        key = 'Today';
      } else if (nDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = 'Earlier';
      }

      grouped.putIfAbsent(key, () => []).add(notification);
    }

    // Sort keys
    final sortedKeys = grouped.keys.toList();
    sortedKeys.sort((a, b) {
      const order = {'Today': 0, 'Yesterday': 1, 'Earlier': 2};
      return (order[a] ?? 3).compareTo(order[b] ?? 3);
    });

    final sortedGrouped = <String, List<AppNotification>>{};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  int _getTypeCount(List<AppNotification> notifications, String type) {
    return notifications.where((n) => n.type == type).length;
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final filteredNotifications = _getFilteredNotifications(notifications);
    final groupedNotifications = _groupByDate(filteredNotifications);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            if (unreadCount > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    ref.read(notificationsProvider.notifier).markAllAsRead();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.done_all, size: 18),
                      SizedBox(width: AppSpacing.sm),
                      const Text('Mark all as read'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: filteredNotifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Filter tabs
                _buildFilterTabs(notifications),

                // Notifications list
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: groupedNotifications.length,
                    itemBuilder: (context, index) {
                      final sectionKey = groupedNotifications.keys.elementAt(
                        index,
                      );
                      final sectionNotifications =
                          groupedNotifications[sectionKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section header
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                              horizontal: AppSpacing.md,
                            ),
                            child: Text(
                              sectionKey,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.foregroundSecondary,
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),

                          // Notifications in this section
                          ...sectionNotifications.map(
                            (notification) =>
                                _buildNotificationCard(notification),
                          ),

                          if (index < groupedNotifications.length - 1)
                            SizedBox(height: AppSpacing.lg),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterTabs(List<AppNotification> notifications) {
    final paymentCount = _getTypeCount(notifications, 'payment_received');
    final requestCount = _getTypeCount(notifications, 'payment_request');
    final completedCount = _getTypeCount(notifications, 'payment_completed');
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            _buildFilterChip(
              'All',
              'all',
              notifications.length,
              _selectedFilter == 'all',
              () => setState(() => _selectedFilter = 'all'),
            ),
            SizedBox(width: AppSpacing.sm),
            if (unreadCount > 0)
              _buildFilterChip(
                'Unread',
                'unread',
                unreadCount,
                _selectedFilter == 'unread',
                () => setState(() => _selectedFilter = 'unread'),
              ),
            if (unreadCount > 0) SizedBox(width: AppSpacing.sm),
            if (paymentCount > 0)
              _buildFilterChip(
                'Payments',
                'payment_received',
                paymentCount,
                _selectedFilter == 'payment_received',
                () => setState(() => _selectedFilter = 'payment_received'),
              ),
            if (paymentCount > 0) SizedBox(width: AppSpacing.sm),
            if (requestCount > 0)
              _buildFilterChip(
                'Requests',
                'payment_request',
                requestCount,
                _selectedFilter == 'payment_request',
                () => setState(() => _selectedFilter = 'payment_request'),
              ),
            if (requestCount > 0) SizedBox(width: AppSpacing.sm),
            if (completedCount > 0)
              _buildFilterChip(
                'Completed',
                'payment_completed',
                completedCount,
                _selectedFilter == 'payment_completed',
                () => setState(() => _selectedFilter = 'payment_completed'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    int count,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.border.withValues(alpha: 0.3),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: AppTypography.bodySmall.copyWith(
        color: isSelected ? AppColors.primary : AppColors.foregroundSecondary,
        fontWeight: isSelected ? AppTypography.semiBold : AppTypography.regular,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.transparent,
        width: isSelected ? 1.5 : 0,
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) {
        ref
            .read(notificationsProvider.notifier)
            .removeNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            ref
                .read(notificationsProvider.notifier)
                .markAsRead(notification.id);
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(
              color: !notification.isRead
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.border,
              width: !notification.isRead ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: !notification.isRead
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification icon/badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(
                        notification.type,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        _getNotificationIcon(notification.type),
                        color: _getNotificationColor(notification.type),
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),

                  // Notification content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.foreground,
                                        fontWeight: AppTypography.semiBold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.sm),
                                  // Status badge
                                  if (notification.status != null)
                                    _buildStatusBadge(notification.status!),
                                ],
                              ),
                            ),
                            // Unread indicator
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          notification.message,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.foregroundSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.md),

              // Amount display (if applicable)
              if (notification.amount != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.type == 'payment_request'
                            ? 'Requested Amount'
                            : 'Amount',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                      Text(
                        '\$${notification.amount!.toStringAsFixed(2)}',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              if (notification.amount != null) SizedBox(height: AppSpacing.md),

              // Sender info (if applicable)
              if (notification.senderName != null)
                Row(
                  children: [
                    if (notification.senderImage != null)
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          notification.senderImage!,
                        ),
                      ),
                    if (notification.senderImage != null)
                      SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'From: ${notification.senderName}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

              if (notification.senderName != null)
                SizedBox(height: AppSpacing.md),

              // Action buttons
              Row(
                children: [
                  if (notification.actionRequired == 'pay')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showPaymentConfirmation(notification);
                        },
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text('Pay Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  if (notification.actionRequired == 'pay')
                    SizedBox(width: AppSpacing.sm),
                  if (notification.actionRequired == 'pay')
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref
                              .read(notificationsProvider.notifier)
                              .declinePaymentRequest(notification.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment request declined'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Decline'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  if (notification.actionRequired != 'pay')
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref
                              .read(notificationsProvider.notifier)
                              .removeNotification(notification.id);
                        },
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Dismiss'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: AppSpacing.md),

              // Timestamp
              Text(
                _formatTimeAgo(notification.timestamp),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.foregroundSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case 'completed':
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        label = 'Completed';
        break;
      case 'pending':
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        label = 'Pending';
        break;
      case 'failed':
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        label = 'Failed';
        break;
      default:
        backgroundColor = AppColors.border.withValues(alpha: 0.3);
        textColor = AppColors.foregroundSecondary;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: textColor,
          fontWeight: AppTypography.semiBold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 40,
              color: AppColors.foregroundSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'No Notifications',
            style: AppTypography.h4.copyWith(color: AppColors.foreground),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            _selectedFilter == 'all'
                ? 'You\'re all caught up!'
                : 'No notifications in this category',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.foregroundSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showPaymentConfirmation(AppNotification notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Payment',
              style: AppTypography.h4.copyWith(color: AppColors.foreground),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      Text(
                        '\$${notification.amount!.toStringAsFixed(2)}',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.foregroundSecondary,
                        ),
                      ),
                      Text(
                        notification.senderName ?? 'Unknown',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.foreground,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(notificationsProvider.notifier)
                          .acceptPaymentRequest(notification.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment processed successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Confirm Payment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'payment_received':
        return Colors.green;
      case 'payment_request':
        return Colors.orange;
      case 'payment_completed':
        return AppColors.primary;
      case 'system':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'payment_received':
        return Icons.account_balance_wallet;
      case 'payment_request':
        return Icons.request_quote;
      case 'payment_completed':
        return Icons.check_circle;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }
}
