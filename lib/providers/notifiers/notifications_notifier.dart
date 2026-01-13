import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/notification.dart';

// Notifications provider
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
      return NotificationsNotifier();
    });

// Filtered notifications provider
final filteredNotificationsProvider =
    Provider<Map<String, List<AppNotification>>>((ref) {
      final notifications = ref.watch(notificationsProvider);

      // Group by type
      final grouped = <String, List<AppNotification>>{};
      for (var notification in notifications) {
        grouped.putIfAbsent(notification.type, () => []).add(notification);
      }

      return grouped;
    });

// Unread count provider
final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier()
    : super([
        AppNotification(
          id: '1',
          type: 'payment_received',
          title: 'Payment Received',
          message: 'You received a payment of \$200.00',
          amount: 200.00,
          senderName: 'John Smith',
          senderImage:
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
          status: 'completed',
        ),
        AppNotification(
          id: '2',
          type: 'payment_request',
          title: 'Payment Request',
          message: 'James Smith is requesting a payment of \$450.00',
          amount: 450.00,
          senderName: 'James Smith',
          senderImage:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isRead: false,
          status: 'pending',
          actionRequired: 'pay',
        ),
        AppNotification(
          id: '3',
          type: 'system',
          title: 'Payment Method Added',
          message: 'Your new payment method has been added successfully',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          isRead: true,
          status: 'completed',
        ),
        AppNotification(
          id: '4',
          type: 'payment_completed',
          title: 'Payment Completed',
          message: 'Your payment of \$600.00 has been completed',
          amount: 600.00,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
          status: 'completed',
        ),
        AppNotification(
          id: '5',
          type: 'payment_request',
          title: 'Payment Request',
          message: 'Wilson Henry is requesting a payment of \$400.00',
          amount: 400.00,
          senderName: 'Wilson Henry',
          senderImage:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          status: 'pending',
          actionRequired: 'pay',
        ),
      ]);

  void markAsRead(String id) {
    final index = state.indexWhere((n) => n.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(isRead: true);
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    }
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void removeNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void updateNotification(AppNotification notification) {
    final index = state.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        notification,
        ...state.sublist(index + 1),
      ];
    }
  }

  void acceptPaymentRequest(String id) {
    final index = state.indexWhere((n) => n.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(
        status: 'completed',
        actionRequired: null,
      );
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    }
  }

  void declinePaymentRequest(String id) {
    removeNotification(id);
  }
}
