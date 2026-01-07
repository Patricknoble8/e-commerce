/// Notification model representing different types of notifications
class AppNotification {
  final String id;
  final String
  type; // 'payment_received', 'payment_request', 'payment_completed', 'system'
  final String title;
  final String message;
  final double? amount; // For payment-related notifications
  final String? senderName;
  final String? senderImage;
  final DateTime timestamp;
  final bool isRead;
  final String? status; // 'pending', 'completed', 'failed'
  final String? actionRequired; // 'pay', 'accept', 'decline'

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.amount,
    this.senderName,
    this.senderImage,
    required this.timestamp,
    this.isRead = false,
    this.status,
    this.actionRequired,
  });

  AppNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    double? amount,
    String? senderName,
    String? senderImage,
    DateTime? timestamp,
    bool? isRead,
    String? status,
    String? actionRequired,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      amount: amount ?? this.amount,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      status: status ?? this.status,
      actionRequired: actionRequired ?? this.actionRequired,
    );
  }
}
