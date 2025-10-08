import 'package:equatable/equatable.dart';

enum TicketStatus {
  open,
  inProgress,
  awaitingInfo,
  resolved,
  closed,
  escalated
}

enum TicketCategory {
  technical,
  administrative,
  financial,
  policy,
  grievance
}

enum TicketPriority {
  low,
  medium,
  high,
  critical
}

class Ticket extends Equatable {
  final String id;
  final String title;
  final String description;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final String submitterId;
  final String submitterName;
  final String submitterRole;
  final String? assigneeId;
  final String? assigneeName;
  final String? assigneeRole;
  final String? contextId; // project_id, request_id, etc.
  final String? contextType; // project, request, scheme, audit
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final DateTime? resolvedAt;
  final List<String> attachments;
  final List<TicketComment> comments;
  final int slaHours;
  final bool isEscalated;
  final String? escalatedTo;
  final DateTime? escalatedAt;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.submitterId,
    required this.submitterName,
    required this.submitterRole,
    this.assigneeId,
    this.assigneeName,
    this.assigneeRole,
    this.contextId,
    this.contextType,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.resolvedAt,
    this.attachments = const [],
    this.comments = const [],
    this.slaHours = 24,
    this.isEscalated = false,
    this.escalatedTo,
    this.escalatedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: TicketCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TicketCategory.technical,
      ),
      priority: TicketPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TicketPriority.medium,
      ),
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.open,
      ),
      submitterId: json['submitter_id'] as String,
      submitterName: json['submitter_name'] as String,
      submitterRole: json['submitter_role'] as String,
      assigneeId: json['assignee_id'] as String?,
      assigneeName: json['assignee_name'] as String?,
      assigneeRole: json['assignee_role'] as String?,
      contextId: json['context_id'] as String?,
      contextType: json['context_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      dueDate: json['due_date'] != null 
          ? DateTime.parse(json['due_date'] as String) 
          : null,
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at'] as String) 
          : null,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => TicketComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      slaHours: json['sla_hours'] as int? ?? 24,
      isEscalated: json['is_escalated'] as bool? ?? false,
      escalatedTo: json['escalated_to'] as String?,
      escalatedAt: json['escalated_at'] != null 
          ? DateTime.parse(json['escalated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'status': status.name,
      'submitter_id': submitterId,
      'submitter_name': submitterName,
      'submitter_role': submitterRole,
      'assignee_id': assigneeId,
      'assignee_name': assigneeName,
      'assignee_role': assigneeRole,
      'context_id': contextId,
      'context_type': contextType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'attachments': attachments,
      'comments': comments.map((c) => c.toJson()).toList(),
      'sla_hours': slaHours,
      'is_escalated': isEscalated,
      'escalated_to': escalatedTo,
      'escalated_at': escalatedAt?.toIso8601String(),
    };
  }

  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    TicketCategory? category,
    TicketPriority? priority,
    TicketStatus? status,
    String? submitterId,
    String? submitterName,
    String? submitterRole,
    String? assigneeId,
    String? assigneeName,
    String? assigneeRole,
    String? contextId,
    String? contextType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? resolvedAt,
    List<String>? attachments,
    List<TicketComment>? comments,
    int? slaHours,
    bool? isEscalated,
    String? escalatedTo,
    DateTime? escalatedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      submitterId: submitterId ?? this.submitterId,
      submitterName: submitterName ?? this.submitterName,
      submitterRole: submitterRole ?? this.submitterRole,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      assigneeRole: assigneeRole ?? this.assigneeRole,
      contextId: contextId ?? this.contextId,
      contextType: contextType ?? this.contextType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
      slaHours: slaHours ?? this.slaHours,
      isEscalated: isEscalated ?? this.isEscalated,
      escalatedTo: escalatedTo ?? this.escalatedTo,
      escalatedAt: escalatedAt ?? this.escalatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        priority,
        status,
        submitterId,
        submitterName,
        submitterRole,
        assigneeId,
        assigneeName,
        assigneeRole,
        contextId,
        contextType,
        createdAt,
        updatedAt,
        dueDate,
        resolvedAt,
        attachments,
        comments,
        slaHours,
        isEscalated,
        escalatedTo,
        escalatedAt,
      ];
}

class TicketComment extends Equatable {
  final String id;
  final String ticketId;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String content;
  final DateTime createdAt;
  final List<String> attachments;
  final bool isInternal; // Only visible to staff, not public users

  const TicketComment({
    required this.id,
    required this.ticketId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.content,
    required this.createdAt,
    this.attachments = const [],
    this.isInternal = false,
  });

  factory TicketComment.fromJson(Map<String, dynamic> json) {
    return TicketComment(
      id: json['id'] as String,
      ticketId: json['ticket_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorRole: json['author_role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isInternal: json['is_internal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'author_id': authorId,
      'author_name': authorName,
      'author_role': authorRole,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'attachments': attachments,
      'is_internal': isInternal,
    };
  }

  @override
  List<Object?> get props => [
        id,
        ticketId,
        authorId,
        authorName,
        authorRole,
        content,
        createdAt,
        attachments,
        isInternal,
      ];
}
