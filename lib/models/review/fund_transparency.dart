import 'package:equatable/equatable.dart';

enum FundTransactionType {
  allocation,
  disbursement,
  utilization,
  refund,
  adjustment
}

enum FundTransactionStatus {
  pending,
  approved,
  rejected,
  onHold,
  completed,
  underAudit
}

class FundTransparencyRecord extends Equatable {
  final String id;
  final String sourceLevel; // centre, state, agency
  final String sourceId;
  final String sourceName;
  final String targetLevel; // state, agency, vendor
  final String targetId;
  final String targetName;
  final FundTransactionType type;
  final FundTransactionStatus status;
  final double amount;
  final String currency;
  final DateTime transactionDate;
  final DateTime? approvalDate;
  final String? pfmsReference;
  final String? budgetLineItem;
  final String? projectId;
  final String? schemeId;
  final String description;
  final List<FundTransactionDocument> documents;
  final List<FundAuditRecord> auditRecords;
  final Map<String, dynamic> metadata;
  final bool requiresAuditApproval;
  final String? auditorId;
  final DateTime? auditDate;
  final String? auditNotes;

  const FundTransparencyRecord({
    required this.id,
    required this.sourceLevel,
    required this.sourceId,
    required this.sourceName,
    required this.targetLevel,
    required this.targetId,
    required this.targetName,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.transactionDate,
    this.approvalDate,
    this.pfmsReference,
    this.budgetLineItem,
    this.projectId,
    this.schemeId,
    required this.description,
    this.documents = const [],
    this.auditRecords = const [],
    this.metadata = const {},
    this.requiresAuditApproval = false,
    this.auditorId,
    this.auditDate,
    this.auditNotes,
  });

  factory FundTransparencyRecord.fromJson(Map<String, dynamic> json) {
    return FundTransparencyRecord(
      id: json['id'] as String,
      sourceLevel: json['source_level'] as String,
      sourceId: json['source_id'] as String,
      sourceName: json['source_name'] as String,
      targetLevel: json['target_level'] as String,
      targetId: json['target_id'] as String,
      targetName: json['target_name'] as String,
      type: FundTransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FundTransactionType.allocation,
      ),
      status: FundTransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FundTransactionStatus.pending,
      ),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      approvalDate: json['approval_date'] != null
          ? DateTime.parse(json['approval_date'] as String)
          : null,
      pfmsReference: json['pfms_reference'] as String?,
      budgetLineItem: json['budget_line_item'] as String?,
      projectId: json['project_id'] as String?,
      schemeId: json['scheme_id'] as String?,
      description: json['description'] as String,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => FundTransactionDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      auditRecords: (json['audit_records'] as List<dynamic>?)
              ?.map((e) => FundAuditRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      requiresAuditApproval: json['requires_audit_approval'] as bool? ?? false,
      auditorId: json['auditor_id'] as String?,
      auditDate: json['audit_date'] != null
          ? DateTime.parse(json['audit_date'] as String)
          : null,
      auditNotes: json['audit_notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_level': sourceLevel,
      'source_id': sourceId,
      'source_name': sourceName,
      'target_level': targetLevel,
      'target_id': targetId,
      'target_name': targetName,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'currency': currency,
      'transaction_date': transactionDate.toIso8601String(),
      'approval_date': approvalDate?.toIso8601String(),
      'pfms_reference': pfmsReference,
      'budget_line_item': budgetLineItem,
      'project_id': projectId,
      'scheme_id': schemeId,
      'description': description,
      'documents': documents.map((d) => d.toJson()).toList(),
      'audit_records': auditRecords.map((a) => a.toJson()).toList(),
      'metadata': metadata,
      'requires_audit_approval': requiresAuditApproval,
      'auditor_id': auditorId,
      'audit_date': auditDate?.toIso8601String(),
      'audit_notes': auditNotes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        sourceLevel,
        sourceId,
        sourceName,
        targetLevel,
        targetId,
        targetName,
        type,
        status,
        amount,
        currency,
        transactionDate,
        approvalDate,
        pfmsReference,
        budgetLineItem,
        projectId,
        schemeId,
        description,
        documents,
        auditRecords,
        metadata,
        requiresAuditApproval,
        auditorId,
        auditDate,
        auditNotes,
      ];
}

class FundTransactionDocument extends Equatable {
  final String id;
  final String transactionId;
  final String name;
  final String type; // bill, receipt, invoice, proof, geotag
  final String fileUrl;
  final String fileName;
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final String uploadedBy;
  final Map<String, dynamic>? geotagData; // lat, lng, timestamp, address
  final bool isVerified;
  final String? verificationNotes;

  const FundTransactionDocument({
    required this.id,
    required this.transactionId,
    required this.name,
    required this.type,
    required this.fileUrl,
    required this.fileName,
    required this.fileSizeBytes,
    required this.uploadedAt,
    required this.uploadedBy,
    this.geotagData,
    this.isVerified = false,
    this.verificationNotes,
  });

  factory FundTransactionDocument.fromJson(Map<String, dynamic> json) {
    return FundTransactionDocument(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String,
      fileSizeBytes: json['file_size_bytes'] as int,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      uploadedBy: json['uploaded_by'] as String,
      geotagData: json['geotag_data'] as Map<String, dynamic>?,
      isVerified: json['is_verified'] as bool? ?? false,
      verificationNotes: json['verification_notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'name': name,
      'type': type,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
      'uploaded_at': uploadedAt.toIso8601String(),
      'uploaded_by': uploadedBy,
      'geotag_data': geotagData,
      'is_verified': isVerified,
      'verification_notes': verificationNotes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        transactionId,
        name,
        type,
        fileUrl,
        fileName,
        fileSizeBytes,
        uploadedAt,
        uploadedBy,
        geotagData,
        isVerified,
        verificationNotes,
      ];
}

class FundAuditRecord extends Equatable {
  final String id;
  final String transactionId;
  final String auditorId;
  final String auditorName;
  final DateTime auditDate;
  final String auditStatus; // approved, rejected, flagged, pending
  final String? auditNotes;
  final List<String> flaggedIssues;
  final double? adjustedAmount;
  final String? adjustmentReason;

  const FundAuditRecord({
    required this.id,
    required this.transactionId,
    required this.auditorId,
    required this.auditorName,
    required this.auditDate,
    required this.auditStatus,
    this.auditNotes,
    this.flaggedIssues = const [],
    this.adjustedAmount,
    this.adjustmentReason,
  });

  factory FundAuditRecord.fromJson(Map<String, dynamic> json) {
    return FundAuditRecord(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      auditorId: json['auditor_id'] as String,
      auditorName: json['auditor_name'] as String,
      auditDate: DateTime.parse(json['audit_date'] as String),
      auditStatus: json['audit_status'] as String,
      auditNotes: json['audit_notes'] as String?,
      flaggedIssues: (json['flagged_issues'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      adjustedAmount: (json['adjusted_amount'] as num?)?.toDouble(),
      adjustmentReason: json['adjustment_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'auditor_id': auditorId,
      'auditor_name': auditorName,
      'audit_date': auditDate.toIso8601String(),
      'audit_status': auditStatus,
      'audit_notes': auditNotes,
      'flagged_issues': flaggedIssues,
      'adjusted_amount': adjustedAmount,
      'adjustment_reason': adjustmentReason,
    };
  }

  @override
  List<Object?> get props => [
        id,
        transactionId,
        auditorId,
        auditorName,
        auditDate,
        auditStatus,
        auditNotes,
        flaggedIssues,
        adjustedAmount,
        adjustmentReason,
      ];
}

class FundUtilizationSummary extends Equatable {
  final String levelId; // centre, state_id, agency_id
  final String levelType; // centre, state, agency
  final String levelName;
  final double totalAllocated;
  final double totalUtilized;
  final double totalPending;
  final double totalOnHold;
  final double utilizationPercentage;
  final int totalTransactions;
  final int pendingAuditCount;
  final DateTime lastUpdated;
  final Map<String, double> categoryBreakdown; // adarsh_gram, hostel, admin
  final List<FundTransparencyRecord> recentTransactions;

  const FundUtilizationSummary({
    required this.levelId,
    required this.levelType,
    required this.levelName,
    required this.totalAllocated,
    required this.totalUtilized,
    required this.totalPending,
    required this.totalOnHold,
    required this.utilizationPercentage,
    required this.totalTransactions,
    required this.pendingAuditCount,
    required this.lastUpdated,
    this.categoryBreakdown = const {},
    this.recentTransactions = const [],
  });

  factory FundUtilizationSummary.fromJson(Map<String, dynamic> json) {
    return FundUtilizationSummary(
      levelId: json['level_id'] as String,
      levelType: json['level_type'] as String,
      levelName: json['level_name'] as String,
      totalAllocated: (json['total_allocated'] as num).toDouble(),
      totalUtilized: (json['total_utilized'] as num).toDouble(),
      totalPending: (json['total_pending'] as num).toDouble(),
      totalOnHold: (json['total_on_hold'] as num).toDouble(),
      utilizationPercentage: (json['utilization_percentage'] as num).toDouble(),
      totalTransactions: json['total_transactions'] as int,
      pendingAuditCount: json['pending_audit_count'] as int,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      categoryBreakdown: (json['category_breakdown'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      recentTransactions: (json['recent_transactions'] as List<dynamic>?)
              ?.map((e) => FundTransparencyRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'level_type': levelType,
      'level_name': levelName,
      'total_allocated': totalAllocated,
      'total_utilized': totalUtilized,
      'total_pending': totalPending,
      'total_on_hold': totalOnHold,
      'utilization_percentage': utilizationPercentage,
      'total_transactions': totalTransactions,
      'pending_audit_count': pendingAuditCount,
      'last_updated': lastUpdated.toIso8601String(),
      'category_breakdown': categoryBreakdown,
      'recent_transactions': recentTransactions.map((t) => t.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        levelId,
        levelType,
        levelName,
        totalAllocated,
        totalUtilized,
        totalPending,
        totalOnHold,
        utilizationPercentage,
        totalTransactions,
        pendingAuditCount,
        lastUpdated,
        categoryBreakdown,
        recentTransactions,
      ];
}
