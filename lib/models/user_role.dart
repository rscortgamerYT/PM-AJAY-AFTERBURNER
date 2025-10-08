import 'package:equatable/equatable.dart';

enum UserRoleType {
  centreAdmin,
  stateOfficer,
  agencyUser,
  auditor,
  publicViewer,
  publicUser;

  String get displayName {
    switch (this) {
      case UserRoleType.centreAdmin:
        return 'Centre Admin';
      case UserRoleType.stateOfficer:
        return 'State Officer';
      case UserRoleType.agencyUser:
        return 'Agency User';
      case UserRoleType.auditor:
        return 'Auditor';
      case UserRoleType.publicViewer:
        return 'Public Viewer';
      case UserRoleType.publicUser:
        return 'Public User';
    }
  }

  static UserRoleType fromString(String value) {
    switch (value) {
      case 'centre_admin':
        return UserRoleType.centreAdmin;
      case 'state_officer':
        return UserRoleType.stateOfficer;
      case 'agency_user':
        return UserRoleType.agencyUser;
      case 'auditor':
        return UserRoleType.auditor;
      case 'public_viewer':
        return UserRoleType.publicViewer;
      case 'public_user':
        return UserRoleType.publicUser;
      default:
        throw ArgumentError('Unknown role type: $value');
    }
  }

  String toDbString() {
    switch (this) {
      case UserRoleType.centreAdmin:
        return 'centre_admin';
      case UserRoleType.stateOfficer:
        return 'state_officer';
      case UserRoleType.agencyUser:
        return 'agency_user';
      case UserRoleType.auditor:
        return 'auditor';
      case UserRoleType.publicViewer:
        return 'public_viewer';
      case UserRoleType.publicUser:
        return 'public_user';
    }
  }
}

class UserRole extends Equatable {
  final String id;
  final String userId;
  final UserRoleType roleType;
  final String? stateCode;
  final String? agencyId;
  final DateTime createdAt;

  const UserRole({
    required this.id,
    required this.userId,
    required this.roleType,
    this.stateCode,
    this.agencyId,
    required this.createdAt,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'],
      userId: json['user_id'],
      roleType: UserRoleType.fromString(json['role_type']),
      stateCode: json['state_code'],
      agencyId: json['agency_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'role_type': roleType.toDbString(),
      'state_code': stateCode,
      'agency_id': agencyId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        roleType,
        stateCode,
        agencyId,
        createdAt,
      ];
}
