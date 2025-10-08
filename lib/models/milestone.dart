import 'package:equatable/equatable.dart';

class Milestone extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime? completedAt;
  final bool isCompleted;
  final double budgetAllocation;
  final String? evidenceUrl;
  final Map<String, dynamic>? metadata;

  const Milestone({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completedAt,
    required this.isCompleted,
    required this.budgetAllocation,
    this.evidenceUrl,
    this.metadata,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['due_date']),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
      isCompleted: json['is_completed'] ?? false,
      budgetAllocation: (json['budget_allocation'] ?? 0).toDouble(),
      evidenceUrl: json['evidence_url'],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'is_completed': isCompleted,
      'budget_allocation': budgetAllocation,
      'evidence_url': evidenceUrl,
      'metadata': metadata,
    };
  }

  bool get isOverdue {
    if (isCompleted) return false;
    return DateTime.now().isAfter(dueDate);
  }

  int get daysUntilDue {
    if (isCompleted) return 0;
    return dueDate.difference(DateTime.now()).inDays;
  }

  Milestone copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? completedAt,
    bool? isCompleted,
    double? budgetAllocation,
    String? evidenceUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Milestone(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      budgetAllocation: budgetAllocation ?? this.budgetAllocation,
      evidenceUrl: evidenceUrl ?? this.evidenceUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        description,
        dueDate,
        completedAt,
        isCompleted,
        budgetAllocation,
        evidenceUrl,
        metadata,
      ];
}
