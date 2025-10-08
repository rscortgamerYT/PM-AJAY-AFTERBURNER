import 'package:equatable/equatable.dart';
import 'milestone.dart';

enum ProjectComponent {
  adarshGram,
  gia,
  hostel;

  String get displayName {
    switch (this) {
      case ProjectComponent.adarshGram:
        return 'Adarsh Gram';
      case ProjectComponent.gia:
        return 'GIA';
      case ProjectComponent.hostel:
        return 'Hostel';
    }
  }

  static ProjectComponent fromString(String value) {
    switch (value) {
      case 'adarsh_gram':
        return ProjectComponent.adarshGram;
      case 'gia':
        return ProjectComponent.gia;
      case 'hostel':
        return ProjectComponent.hostel;
      default:
        throw ArgumentError('Unknown component: $value');
    }
  }

  String toDbString() {
    switch (this) {
      case ProjectComponent.adarshGram:
        return 'adarsh_gram';
      case ProjectComponent.gia:
        return 'gia';
      case ProjectComponent.hostel:
        return 'hostel';
    }
  }
}

enum ProjectStatus {
  draft,
  active,
  completed,
  suspended;

  String get displayName {
    switch (this) {
      case ProjectStatus.draft:
        return 'Draft';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.suspended:
        return 'Suspended';
    }
  }

  static ProjectStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return ProjectStatus.draft;
      case 'active':
        return ProjectStatus.active;
      case 'completed':
        return ProjectStatus.completed;
      case 'suspended':
        return ProjectStatus.suspended;
      default:
        throw ArgumentError('Unknown status: $value');
    }
  }

  String toDbString() {
    switch (this) {
      case ProjectStatus.draft:
        return 'draft';
      case ProjectStatus.active:
        return 'active';
      case ProjectStatus.completed:
        return 'completed';
      case ProjectStatus.suspended:
        return 'suspended';
    }
  }
}

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final ProjectComponent component;
  final String stateCode;
  final String? agencyId;
  final ProjectStatus status;
  final double budgetAllocated;
  final double utilization;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Milestone> milestones;
  final Map<String, dynamic>? metadata;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.component,
    required this.stateCode,
    this.agencyId,
    required this.status,
    required this.budgetAllocated,
    required this.utilization,
    required this.createdAt,
    this.updatedAt,
    required this.milestones,
    this.metadata,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      component: ProjectComponent.fromString(json['component']),
      stateCode: json['state_code'],
      agencyId: json['agency_id'],
      status: ProjectStatus.fromString(json['status']),
      budgetAllocated: (json['budget_allocated'] ?? 0).toDouble(),
      utilization: (json['utilization'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((m) => Milestone.fromJson(m))
              .toList() ?? [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'component': component.toDbString(),
      'state_code': stateCode,
      'agency_id': agencyId,
      'status': status.toDbString(),
      'budget_allocated': budgetAllocated,
      'utilization': utilization,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  double get utilizationPercentage {
    if (budgetAllocated == 0) return 0;
    return (utilization / budgetAllocated) * 100;
  }

  int get completedMilestones {
    return milestones.where((m) => m.isCompleted).length;
  }

  double get progressPercentage {
    if (milestones.isEmpty) return 0;
    return (completedMilestones / milestones.length) * 100;
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    ProjectComponent? component,
    String? stateCode,
    String? agencyId,
    ProjectStatus? status,
    double? budgetAllocated,
    double? utilization,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Milestone>? milestones,
    Map<String, dynamic>? metadata,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      component: component ?? this.component,
      stateCode: stateCode ?? this.stateCode,
      agencyId: agencyId ?? this.agencyId,
      status: status ?? this.status,
      budgetAllocated: budgetAllocated ?? this.budgetAllocated,
      utilization: utilization ?? this.utilization,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      milestones: milestones ?? this.milestones,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        component,
        stateCode,
        agencyId,
        status,
        budgetAllocated,
        utilization,
        createdAt,
        updatedAt,
        milestones,
        metadata,
      ];
}
