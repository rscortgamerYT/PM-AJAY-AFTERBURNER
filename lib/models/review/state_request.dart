import 'package:equatable/equatable.dart';

enum StateRequestType {
  participation,
  budgetIncrease,
  schemeModification,
  agencyApproval,
  fundRelease,
  policyException
}

enum StateRequestStatus {
  submitted,
  underReview,
  onHold,
  approved,
  disapproved,
  requiresInfo
}

enum StateRequestPriority {
  low,
  medium,
  high,
  urgent
}

class StateRequest extends Equatable {
  final String id;
  final String stateId;
  final String stateName;
  final StateRequestType type;
  final StateRequestStatus status;
  final StateRequestPriority priority;
  final String title;
  final String description;
  final String submitterId;
  final String submitterName;
  final String submitterRole;
  final DateTime submittedDate;
  final DateTime? reviewDeadline;
  final DateTime? lastUpdated;
  final DateTime? approvedDate;
  final String? reviewerId;
  final String? reviewerName;
  final String? decisionRationale;
  final List<String> requiredDocuments;
  final List<StateRequestDocument> attachedDocuments;
  final Map<String, dynamic> requestData; // Flexible data for different request types
  final List<StateRequestComment> comments;
  final int slaHours;
  final bool isEscalated;
  final String? escalatedTo;
  final DateTime? escalatedAt;
  final double completenessScore; // 0.0 to 1.0

  const StateRequest({
    required this.id,
    required this.stateId,
    required this.stateName,
    required this.type,
    required this.status,
    required this.priority,
    required this.title,
    required this.description,
    required this.submitterId,
    required this.submitterName,
    required this.submitterRole,
    required this.submittedDate,
    this.reviewDeadline,
    this.lastUpdated,
    this.approvedDate,
    this.reviewerId,
    this.reviewerName,
    this.decisionRationale,
    this.requiredDocuments = const [],
    this.attachedDocuments = const [],
    this.requestData = const {},
    this.comments = const [],
    this.slaHours = 72,
    this.isEscalated = false,
    this.escalatedTo,
    this.escalatedAt,
    this.completenessScore = 0.0,
  });

  factory StateRequest.fromJson(Map<String, dynamic> json) {
    return StateRequest(
      id: json['id'] as String,
      stateId: json['state_id'] as String,
      stateName: json['state_name'] as String,
      type: StateRequestType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StateRequestType.participation,
      ),
      status: StateRequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StateRequestStatus.submitted,
      ),
      priority: StateRequestPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => StateRequestPriority.medium,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      submitterId: json['submitter_id'] as String,
      submitterName: json['submitter_name'] as String,
      submitterRole: json['submitter_role'] as String,
      submittedDate: DateTime.parse(json['submitted_date'] as String),
      reviewDeadline: json['review_deadline'] != null
          ? DateTime.parse(json['review_deadline'] as String)
          : null,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
      approvedDate: json['approved_date'] != null
          ? DateTime.parse(json['approved_date'] as String)
          : null,
      reviewerId: json['reviewer_id'] as String?,
      reviewerName: json['reviewer_name'] as String?,
      decisionRationale: json['decision_rationale'] as String?,
      requiredDocuments: (json['required_documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      attachedDocuments: (json['attached_documents'] as List<dynamic>?)
              ?.map((e) => StateRequestDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      requestData: json['request_data'] as Map<String, dynamic>? ?? {},
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => StateRequestComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      slaHours: json['sla_hours'] as int? ?? 72,
      isEscalated: json['is_escalated'] as bool? ?? false,
      escalatedTo: json['escalated_to'] as String?,
      escalatedAt: json['escalated_at'] != null
          ? DateTime.parse(json['escalated_at'] as String)
          : null,
      completenessScore: (json['completeness_score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_id': stateId,
      'state_name': stateName,
      'type': type.name,
      'status': status.name,
      'priority': priority.name,
      'title': title,
      'description': description,
      'submitter_id': submitterId,
      'submitter_name': submitterName,
      'submitter_role': submitterRole,
      'submitted_date': submittedDate.toIso8601String(),
      'review_deadline': reviewDeadline?.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'approved_date': approvedDate?.toIso8601String(),
      'reviewer_id': reviewerId,
      'reviewer_name': reviewerName,
      'decision_rationale': decisionRationale,
      'required_documents': requiredDocuments,
      'attached_documents': attachedDocuments.map((d) => d.toJson()).toList(),
      'request_data': requestData,
      'comments': comments.map((c) => c.toJson()).toList(),
      'sla_hours': slaHours,
      'is_escalated': isEscalated,
      'escalated_to': escalatedTo,
      'escalated_at': escalatedAt?.toIso8601String(),
      'completeness_score': completenessScore,
    };
  }

  StateRequest copyWith({
    String? id,
    String? stateId,
    String? stateName,
    StateRequestType? type,
    StateRequestStatus? status,
    StateRequestPriority? priority,
    String? title,
    String? description,
    String? submitterId,
    String? submitterName,
    String? submitterRole,
    DateTime? submittedDate,
    DateTime? reviewDeadline,
    DateTime? lastUpdated,
    DateTime? approvedDate,
    String? reviewerId,
    String? reviewerName,
    String? decisionRationale,
    List<String>? requiredDocuments,
    List<StateRequestDocument>? attachedDocuments,
    Map<String, dynamic>? requestData,
    List<StateRequestComment>? comments,
    int? slaHours,
    bool? isEscalated,
    String? escalatedTo,
    DateTime? escalatedAt,
    double? completenessScore,
  }) {
    return StateRequest(
      id: id ?? this.id,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      submitterId: submitterId ?? this.submitterId,
      submitterName: submitterName ?? this.submitterName,
      submitterRole: submitterRole ?? this.submitterRole,
      submittedDate: submittedDate ?? this.submittedDate,
      reviewDeadline: reviewDeadline ?? this.reviewDeadline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      approvedDate: approvedDate ?? this.approvedDate,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      decisionRationale: decisionRationale ?? this.decisionRationale,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      attachedDocuments: attachedDocuments ?? this.attachedDocuments,
      requestData: requestData ?? this.requestData,
      comments: comments ?? this.comments,
      slaHours: slaHours ?? this.slaHours,
      isEscalated: isEscalated ?? this.isEscalated,
      escalatedTo: escalatedTo ?? this.escalatedTo,
      escalatedAt: escalatedAt ?? this.escalatedAt,
      completenessScore: completenessScore ?? this.completenessScore,
    );
  }

  @override
  List<Object?> get props => [
        id,
        stateId,
        stateName,
        type,
        status,
        priority,
        title,
        description,
        submitterId,
        submitterName,
        submitterRole,
        submittedDate,
        reviewDeadline,
        lastUpdated,
        approvedDate,
        reviewerId,
        reviewerName,
        decisionRationale,
        requiredDocuments,
        attachedDocuments,
        requestData,
        comments,
        slaHours,
        isEscalated,
        escalatedTo,
        escalatedAt,
        completenessScore,
      ];
}

class StateRequestDocument extends Equatable {
  final String id;
  final String requestId;
  final String name;
  final String type; // hierarchy, financial, supporting_study
  final String fileUrl;
  final String fileName;
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final String uploadedBy;
  final int version;
  final bool isRequired;
  final bool isVerified;
  final String? verificationNotes;

  const StateRequestDocument({
    required this.id,
    required this.requestId,
    required this.name,
    required this.type,
    required this.fileUrl,
    required this.fileName,
    required this.fileSizeBytes,
    required this.uploadedAt,
    required this.uploadedBy,
    this.version = 1,
    this.isRequired = false,
    this.isVerified = false,
    this.verificationNotes,
  });

  factory StateRequestDocument.fromJson(Map<String, dynamic> json) {
    return StateRequestDocument(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String,
      fileSizeBytes: json['file_size_bytes'] as int,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      uploadedBy: json['uploaded_by'] as String,
      version: json['version'] as int? ?? 1,
      isRequired: json['is_required'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
      verificationNotes: json['verification_notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'name': name,
      'type': type,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
      'uploaded_at': uploadedAt.toIso8601String(),
      'uploaded_by': uploadedBy,
      'version': version,
      'is_required': isRequired,
      'is_verified': isVerified,
      'verification_notes': verificationNotes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        requestId,
        name,
        type,
        fileUrl,
        fileName,
        fileSizeBytes,
        uploadedAt,
        uploadedBy,
        version,
        isRequired,
        isVerified,
        verificationNotes,
      ];
}

class StateRequestComment extends Equatable {
  final String id;
  final String requestId;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String content;
  final DateTime createdAt;
  final bool isInternal;
  final List<String> attachments;

  const StateRequestComment({
    required this.id,
    required this.requestId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.content,
    required this.createdAt,
    this.isInternal = false,
    this.attachments = const [],
  });

  factory StateRequestComment.fromJson(Map<String, dynamic> json) {
    return StateRequestComment(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorRole: json['author_role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isInternal: json['is_internal'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'author_id': authorId,
      'author_name': authorName,
      'author_role': authorRole,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_internal': isInternal,
      'attachments': attachments,
    };
  }

  @override
  List<Object?> get props => [
        id,
        requestId,
        authorId,
        authorName,
        authorRole,
        content,
        createdAt,
        isInternal,
        attachments,
      ];
}
