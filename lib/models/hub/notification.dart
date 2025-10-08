import 'package:equatable/equatable.dart';

enum NotificationType {
  message,
  ticketUpdate,
  deadlineReminder,
  approvalDecision,
  escalationAlert,
  meetingReminder,
  documentShared,
  systemAlert
}

enum NotificationPriority {
  low,
  medium,
  high,
  critical
}

class HubNotification extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final String? contextId; // ticket_id, message_id, meeting_id, etc.
  final String? contextType; // ticket, message, meeting, document
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;
  final bool isDelivered;
  final DateTime? deliveredAt;
  final String? actionUrl; // Deep link to relevant screen

  const HubNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    this.contextId,
    this.contextType,
    this.metadata,
    required this.createdAt,
    this.isRead = false,
    this.readAt,
    this.isDelivered = false,
    this.deliveredAt,
    this.actionUrl,
  });

  factory HubNotification.fromJson(Map<String, dynamic> json) {
    return HubNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.systemAlert,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      contextId: json['context_id'] as String?,
      contextType: json['context_type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null 
          ? DateTime.parse(json['read_at'] as String) 
          : null,
      isDelivered: json['is_delivered'] as bool? ?? false,
      deliveredAt: json['delivered_at'] != null 
          ? DateTime.parse(json['delivered_at'] as String) 
          : null,
      actionUrl: json['action_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'priority': priority.name,
      'context_id': contextId,
      'context_type': contextType,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'is_delivered': isDelivered,
      'delivered_at': deliveredAt?.toIso8601String(),
      'action_url': actionUrl,
    };
  }

  HubNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    String? contextId,
    String? contextType,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    bool? isRead,
    DateTime? readAt,
    bool? isDelivered,
    DateTime? deliveredAt,
    String? actionUrl,
  }) {
    return HubNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      contextId: contextId ?? this.contextId,
      contextType: contextType ?? this.contextType,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        message,
        type,
        priority,
        contextId,
        contextType,
        metadata,
        createdAt,
        isRead,
        readAt,
        isDelivered,
        deliveredAt,
        actionUrl,
      ];
}

class NotificationSettings extends Equatable {
  final String userId;
  final bool inAppNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final Map<NotificationType, bool> typePreferences;
  final Map<NotificationPriority, bool> priorityPreferences;
  final bool quietHoursEnabled;
  final int quietHoursStart; // Hour of day (0-23)
  final int quietHoursEnd; // Hour of day (0-23)

  const NotificationSettings({
    required this.userId,
    this.inAppNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.typePreferences = const {},
    this.priorityPreferences = const {},
    this.quietHoursEnabled = false,
    this.quietHoursStart = 22, // 10 PM
    this.quietHoursEnd = 8, // 8 AM
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      userId: json['user_id'] as String,
      inAppNotifications: json['in_app_notifications'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      smsNotifications: json['sms_notifications'] as bool? ?? false,
      typePreferences: (json['type_preferences'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(
                  NotificationType.values.firstWhere((e) => e.name == k),
                  v as bool)) ??
          {},
      priorityPreferences: (json['priority_preferences'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(
                  NotificationPriority.values.firstWhere((e) => e.name == k),
                  v as bool)) ??
          {},
      quietHoursEnabled: json['quiet_hours_enabled'] as bool? ?? false,
      quietHoursStart: json['quiet_hours_start'] as int? ?? 22,
      quietHoursEnd: json['quiet_hours_end'] as int? ?? 8,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'in_app_notifications': inAppNotifications,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'type_preferences': typePreferences
          .map((k, v) => MapEntry(k.name, v)),
      'priority_preferences': priorityPreferences
          .map((k, v) => MapEntry(k.name, v)),
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        inAppNotifications,
        emailNotifications,
        smsNotifications,
        typePreferences,
        priorityPreferences,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
      ];
}
