class ChatMessage {
  final String id;
  final String channelId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String content;
  final DateTime timestamp;
  final List<String> attachments;
  final String? replyToId;
  final bool isRead;
  final List<String> readBy;
  final Map<String, int> reactions; // emoji -> count

  ChatMessage({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.content,
    required this.timestamp,
    this.attachments = const [],
    this.replyToId,
    this.isRead = false,
    this.readBy = const [],
    this.reactions = const {},
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      senderRole: json['sender_role'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      replyToId: json['reply_to_id'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readBy: (json['read_by'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reactions: (json['reactions'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments,
      'reply_to_id': replyToId,
      'is_read': isRead,
      'read_by': readBy,
      'reactions': reactions,
    };
  }
}

class ChatChannel {
  final String id;
  final String name;
  final String type; // centre_state, state_agency, centre_auditor, public_forum
  final String? contextId; // project_id, request_id, etc.
  final String? contextType; // project, request, scheme, audit
  final List<String> participants;
  final Map<String, String> participantRoles;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final int unreadCount;
  final ChatMessage? lastMessage;

  ChatChannel({
    required this.id,
    required this.name,
    required this.type,
    this.contextId,
    this.contextType,
    required this.participants,
    required this.participantRoles,
    required this.createdAt,
    required this.lastActivityAt,
    this.unreadCount = 0,
    this.lastMessage,
  });

  factory ChatChannel.fromJson(Map<String, dynamic> json) {
    return ChatChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      contextId: json['context_id'] as String?,
      contextType: json['context_type'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantRoles: (json['participant_roles'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as String)),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivityAt: DateTime.parse(json['last_activity_at'] as String),
      unreadCount: json['unread_count'] as int? ?? 0,
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'context_id': contextId,
      'context_type': contextType,
      'participants': participants,
      'participant_roles': participantRoles,
      'created_at': createdAt.toIso8601String(),
      'last_activity_at': lastActivityAt.toIso8601String(),
      'unread_count': unreadCount,
      'last_message': lastMessage?.toJson(),
    };
  }
}