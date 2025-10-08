import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pmajay_app/models/requests/notification.dart';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Watch notifications (real-time)
  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('recipient_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => AppNotification.fromJson(json)).toList());
  }

  // Get notifications list
  Future<List<AppNotification>> getNotifications({
    required String userId,
    bool? readStatus,
    bool? actionRequired,
  }) async {
    var query = _supabase
        .from('notifications')
        .select()
        .eq('recipient_id', userId);

    if (readStatus != null) {
      query = query.eq('read_status', readStatus);
    }

    if (actionRequired != null) {
      query = query.eq('action_required', actionRequired);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => AppNotification.fromJson(json))
        .toList();
  }

  // Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    final response = await _supabase
        .from('notifications')
        .select('id')
        .eq('recipient_id', userId)
        .eq('read_status', false);

    return (response as List).length;
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'read_status': true})
        .eq('id', notificationId);
  }

  // Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    await _supabase
        .from('notifications')
        .update({'read_status': true})
        .eq('recipient_id', userId)
        .eq('read_status', false);
  }

  // Send notification
  Future<void> sendNotification({
    required String recipientId,
    required String notificationType,
    required String title,
    required String message,
    String? relatedEntityType,
    String? relatedEntityId,
    String priority = 'medium',
    bool actionRequired = false,
    String? actionUrl,
    String? senderId,
  }) async {
    await _supabase.from('notifications').insert({
      'recipient_id': recipientId,
      'sender_id': senderId ?? _supabase.auth.currentUser?.id,
      'notification_type': notificationType,
      'title': title,
      'message': message,
      'related_entity_type': relatedEntityType,
      'related_entity_id': relatedEntityId,
      'priority': priority,
      'action_required': actionRequired,
      'action_url': actionUrl,
    });
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId);
  }

  // Delete all notifications for a user
  Future<void> deleteAllNotifications(String userId) async {
    await _supabase
        .from('notifications')
        .delete()
        .eq('recipient_id', userId);
  }
}