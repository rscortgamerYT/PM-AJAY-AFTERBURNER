class AppNotification {
  final String id;
  final String recipientId;
  final String? senderId;
  final String notificationType;
  final String title;
  final String message;
  final String? relatedEntityType;
  final String? relatedEntityId;
  final String priority;
  final bool readStatus;
  final bool actionRequired;
  final String? actionUrl;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.recipientId,
    this.senderId,
    required this.notificationType,
    required this.title,
    required this.message,
    this.relatedEntityType,
    this.relatedEntityId,
    required this.priority,
    required this.readStatus,
    required this.actionRequired,
    this.actionUrl,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      recipientId: json['recipient_id'] ?? '',
      senderId: json['sender_id'],
      notificationType: json['notification_type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      relatedEntityType: json['related_entity_type'],
      relatedEntityId: json['related_entity_id'],
      priority: json['priority'] ?? 'medium',
      readStatus: json['read_status'] ?? false,
      actionRequired: json['action_required'] ?? false,
      actionUrl: json['action_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipient_id': recipientId,
      'sender_id': senderId,
      'notification_type': notificationType,
      'title': title,
      'message': message,
      'related_entity_type': relatedEntityType,
      'related_entity_id': relatedEntityId,
      'priority': priority,
      'read_status': readStatus,
      'action_required': actionRequired,
      'action_url': actionUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}