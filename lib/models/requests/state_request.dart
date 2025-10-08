import 'package:pmajay_app/models/requests/document_reference.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class StateRequest {
  final String id;
  final String stateCode;
  final StateRequestType requestType;
  final String title;
  final String description;
  final double? requestedAmount;
  final PriorityLevel priority;
  final List<DocumentReference> documents;
  final HierarchyDetails hierarchyDetails;
  final StateOfficerDetails officerDetails;
  final RequestStatus status;
  final String? centreReviewerId;
  final String? centreReviewNotes;
  final String? approvedGuidelines;
  final List<String>? requiredDocuments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reviewedAt;

  StateRequest({
    required this.id,
    required this.stateCode,
    required this.requestType,
    required this.title,
    required this.description,
    this.requestedAmount,
    required this.priority,
    required this.documents,
    required this.hierarchyDetails,
    required this.officerDetails,
    required this.status,
    this.centreReviewerId,
    this.centreReviewNotes,
    this.approvedGuidelines,
    this.requiredDocuments,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedAt,
  });

  factory StateRequest.fromJson(Map<String, dynamic> json) {
    return StateRequest(
      id: json['id'] ?? '',
      stateCode: json['state_code'] ?? '',
      requestType: StateRequestType.fromString(json['request_type'] ?? 'fund_allocation'),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requestedAmount: json['requested_amount']?.toDouble(),
      priority: PriorityLevel.fromString(json['priority_level'] ?? 'medium'),
      documents: (json['documents'] as List?)
              ?.map((doc) => DocumentReference.fromJson(doc))
              .toList() ??
          [],
      hierarchyDetails: HierarchyDetails.fromJson(json['hierarchy_details'] ?? {}),
      officerDetails: StateOfficerDetails.fromJson(json['state_officer_details'] ?? {}),
      status: RequestStatus.fromString(json['status'] ?? 'submitted'),
      centreReviewerId: json['centre_reviewer_id'],
      centreReviewNotes: json['centre_review_notes'],
      approvedGuidelines: json['approved_guidelines'],
      requiredDocuments: (json['required_documents'] as List?)?.cast<String>(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_code': stateCode,
      'request_type': requestType.value,
      'title': title,
      'description': description,
      'requested_amount': requestedAmount,
      'priority_level': priority.value,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'hierarchy_details': hierarchyDetails.toJson(),
      'state_officer_details': officerDetails.toJson(),
      'status': status.value,
      'centre_reviewer_id': centreReviewerId,
      'centre_review_notes': centreReviewNotes,
      'approved_guidelines': approvedGuidelines,
      'required_documents': requiredDocuments,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }
}

class HierarchyDetails {
  final String chiefSecretary;
  final String principalSecretary;
  final String secretarySocialJustice;
  final String directorSocialWelfare;
  final List<DistrictOfficer> districtOfficers;

  HierarchyDetails({
    required this.chiefSecretary,
    required this.principalSecretary,
    required this.secretarySocialJustice,
    required this.directorSocialWelfare,
    required this.districtOfficers,
  });

  factory HierarchyDetails.fromJson(Map<String, dynamic> json) {
    return HierarchyDetails(
      chiefSecretary: json['chief_secretary'] ?? '',
      principalSecretary: json['principal_secretary'] ?? '',
      secretarySocialJustice: json['secretary_social_justice'] ?? '',
      directorSocialWelfare: json['director_social_welfare'] ?? '',
      districtOfficers: (json['district_officers'] as List?)
              ?.map((officer) => DistrictOfficer.fromJson(officer))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chief_secretary': chiefSecretary,
      'principal_secretary': principalSecretary,
      'secretary_social_justice': secretarySocialJustice,
      'director_social_welfare': directorSocialWelfare,
      'district_officers': districtOfficers.map((officer) => officer.toJson()).toList(),
    };
  }
}

class DistrictOfficer {
  final String name;
  final String district;
  final String designation;
  final String email;
  final String phone;

  DistrictOfficer({
    required this.name,
    required this.district,
    required this.designation,
    required this.email,
    required this.phone,
  });

  factory DistrictOfficer.fromJson(Map<String, dynamic> json) {
    return DistrictOfficer(
      name: json['name'] ?? '',
      district: json['district'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'district': district,
      'designation': designation,
      'email': email,
      'phone': phone,
    };
  }
}

class StateOfficerDetails {
  final String name;
  final String designation;
  final String email;
  final String phone;
  final String employeeId;
  final DateTime appointmentDate;

  StateOfficerDetails({
    required this.name,
    required this.designation,
    required this.email,
    required this.phone,
    required this.employeeId,
    required this.appointmentDate,
  });

  factory StateOfficerDetails.fromJson(Map<String, dynamic> json) {
    return StateOfficerDetails(
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      employeeId: json['employee_id'] ?? '',
      appointmentDate: json['appointment_date'] != null
          ? DateTime.parse(json['appointment_date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'email': email,
      'phone': phone,
      'employee_id': employeeId,
      'appointment_date': appointmentDate.toIso8601String(),
    };
  }
}