import 'package:equatable/equatable.dart';

enum MeetingStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  postponed
}

enum MeetingType {
  projectReview,
  auditDiscussion,
  policyMeeting,
  stateCoordination,
  agencyBriefing,
  publicConsultation,
  other
}

class Meeting extends Equatable {
  final String id;
  final String title;
  final String description;
  final MeetingType type;
  final MeetingStatus status;
  final String organizerId;
  final String organizerName;
  final String organizerRole;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String? contextId; // project_id, request_id, audit_id
  final String? contextType; // project, request, audit, scheme
  final List<MeetingParticipant> participants;
  final List<String> agenda;
  final String? meetingUrl; // For virtual meetings
  final String? location; // For physical meetings
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> attachments;
  final String? minutesDocumentId;
  final List<ActionItem> actionItems;
  final bool isRecurring;
  final String? recurrencePattern;

  const Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.organizerId,
    required this.organizerName,
    required this.organizerRole,
    required this.scheduledAt,
    required this.durationMinutes,
    this.contextId,
    this.contextType,
    this.participants = const [],
    this.agenda = const [],
    this.meetingUrl,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.attachments = const [],
    this.minutesDocumentId,
    this.actionItems = const [],
    this.isRecurring = false,
    this.recurrencePattern,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: MeetingType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MeetingType.other,
      ),
      status: MeetingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MeetingStatus.scheduled,
      ),
      organizerId: json['organizer_id'] as String,
      organizerName: json['organizer_name'] as String,
      organizerRole: json['organizer_role'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: json['duration_minutes'] as int,
      contextId: json['context_id'] as String?,
      contextType: json['context_type'] as String?,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => MeetingParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      agenda: (json['agenda'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      meetingUrl: json['meeting_url'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      minutesDocumentId: json['minutes_document_id'] as String?,
      actionItems: (json['action_items'] as List<dynamic>?)
              ?.map((e) => ActionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurrencePattern: json['recurrence_pattern'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'organizer_id': organizerId,
      'organizer_name': organizerName,
      'organizer_role': organizerRole,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'context_id': contextId,
      'context_type': contextType,
      'participants': participants.map((p) => p.toJson()).toList(),
      'agenda': agenda,
      'meeting_url': meetingUrl,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'attachments': attachments,
      'minutes_document_id': minutesDocumentId,
      'action_items': actionItems.map((a) => a.toJson()).toList(),
      'is_recurring': isRecurring,
      'recurrence_pattern': recurrencePattern,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        status,
        organizerId,
        organizerName,
        organizerRole,
        scheduledAt,
        durationMinutes,
        contextId,
        contextType,
        participants,
        agenda,
        meetingUrl,
        location,
        createdAt,
        updatedAt,
        attachments,
        minutesDocumentId,
        actionItems,
        isRecurring,
        recurrencePattern,
      ];
}

class MeetingParticipant extends Equatable {
  final String userId;
  final String name;
  final String role;
  final String email;
  final bool isRequired;
  final bool hasAccepted;
  final DateTime? respondedAt;
  final bool hasJoined;
  final DateTime? joinedAt;
  final DateTime? leftAt;

  const MeetingParticipant({
    required this.userId,
    required this.name,
    required this.role,
    required this.email,
    this.isRequired = false,
    this.hasAccepted = false,
    this.respondedAt,
    this.hasJoined = false,
    this.joinedAt,
    this.leftAt,
  });

  factory MeetingParticipant.fromJson(Map<String, dynamic> json) {
    return MeetingParticipant(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      email: json['email'] as String,
      isRequired: json['is_required'] as bool? ?? false,
      hasAccepted: json['has_accepted'] as bool? ?? false,
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
      hasJoined: json['has_joined'] as bool? ?? false,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : null,
      leftAt: json['left_at'] != null
          ? DateTime.parse(json['left_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'role': role,
      'email': email,
      'is_required': isRequired,
      'has_accepted': hasAccepted,
      'responded_at': respondedAt?.toIso8601String(),
      'has_joined': hasJoined,
      'joined_at': joinedAt?.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        role,
        email,
        isRequired,
        hasAccepted,
        respondedAt,
        hasJoined,
        joinedAt,
        leftAt,
      ];
}

class ActionItem extends Equatable {
  final String id;
  final String meetingId;
  final String title;
  final String description;
  final String assigneeId;
  final String assigneeName;
  final String assigneeRole;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? completionNotes;
  final DateTime createdAt;

  const ActionItem({
    required this.id,
    required this.meetingId,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.assigneeName,
    required this.assigneeRole,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.completionNotes,
    required this.createdAt,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      id: json['id'] as String,
      meetingId: json['meeting_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      assigneeId: json['assignee_id'] as String,
      assigneeName: json['assignee_name'] as String,
      assigneeRole: json['assignee_role'] as String,
      dueDate: DateTime.parse(json['due_date'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      completionNotes: json['completion_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meeting_id': meetingId,
      'title': title,
      'description': description,
      'assignee_id': assigneeId,
      'assignee_name': assigneeName,
      'assignee_role': assigneeRole,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'completion_notes': completionNotes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        meetingId,
        title,
        description,
        assigneeId,
        assigneeName,
        assigneeRole,
        dueDate,
        isCompleted,
        completedAt,
        completionNotes,
        createdAt,
      ];
}
