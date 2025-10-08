import 'package:pmajay_app/models/requests/document_reference.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class AgencyRequest {
  final String id;
  final String agencyName;
  final AgencyType agencyType;
  final String stateCode;
  final List<DocumentReference> registrationDocuments;
  final GeographicalCoverage geographicalCoverage;
  final TechnicalExpertise technicalExpertise;
  final FinancialCapacity financialCapacity;
  final List<ProjectExperience> previousExperience;
  final List<KeyPersonnel> keyPersonnel;
  final List<SchemeComponent> proposedComponents;
  final RequestStatus status;
  final String? stateReviewerId;
  final String? stateReviewNotes;
  final VerificationChecklist? verificationChecklist;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reviewedAt;

  AgencyRequest({
    required this.id,
    required this.agencyName,
    required this.agencyType,
    required this.stateCode,
    required this.registrationDocuments,
    required this.geographicalCoverage,
    required this.technicalExpertise,
    required this.financialCapacity,
    required this.previousExperience,
    required this.keyPersonnel,
    required this.proposedComponents,
    required this.status,
    this.stateReviewerId,
    this.stateReviewNotes,
    this.verificationChecklist,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedAt,
  });

  factory AgencyRequest.fromJson(Map<String, dynamic> json) {
    return AgencyRequest(
      id: json['id'] ?? '',
      agencyName: json['agency_name'] ?? '',
      agencyType: AgencyType.fromString(json['agency_type'] ?? 'government'),
      stateCode: json['state_code'] ?? '',
      registrationDocuments: (json['registration_documents'] as List?)
              ?.map((doc) => DocumentReference.fromJson(doc))
              .toList() ??
          [],
      geographicalCoverage: GeographicalCoverage.fromJson(json['geographical_coverage'] ?? {}),
      technicalExpertise: TechnicalExpertise.fromJson(json['technical_expertise'] ?? {}),
      financialCapacity: FinancialCapacity.fromJson(json['financial_capacity'] ?? {}),
      previousExperience: (json['previous_experience'] as List?)
              ?.map((exp) => ProjectExperience.fromJson(exp))
              .toList() ??
          [],
      keyPersonnel: (json['key_personnel'] as List?)
              ?.map((person) => KeyPersonnel.fromJson(person))
              .toList() ??
          [],
      proposedComponents: (json['proposed_components'] as List?)
              ?.map((comp) => SchemeComponent.fromString(comp))
              .toList() ??
          [],
      status: RequestStatus.fromString(json['status'] ?? 'submitted'),
      stateReviewerId: json['state_reviewer_id'],
      stateReviewNotes: json['state_review_notes'],
      verificationChecklist: json['verification_checklist'] != null
          ? VerificationChecklist.fromJson(json['verification_checklist'])
          : null,
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
      'agency_name': agencyName,
      'agency_type': agencyType.value,
      'state_code': stateCode,
      'registration_documents': registrationDocuments.map((doc) => doc.toJson()).toList(),
      'geographical_coverage': geographicalCoverage.toJson(),
      'technical_expertise': technicalExpertise.toJson(),
      'financial_capacity': financialCapacity.toJson(),
      'previous_experience': previousExperience.map((exp) => exp.toJson()).toList(),
      'key_personnel': keyPersonnel.map((person) => person.toJson()).toList(),
      'proposed_components': proposedComponents.map((comp) => comp.value).toList(),
      'status': status.value,
      'state_reviewer_id': stateReviewerId,
      'state_review_notes': stateReviewNotes,
      'verification_checklist': verificationChecklist?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }
}

class GeographicalCoverage {
  final List<String> districts;
  final List<String> blocks;
  final String coverageArea;

  GeographicalCoverage({
    required this.districts,
    required this.blocks,
    required this.coverageArea,
  });

  factory GeographicalCoverage.fromJson(Map<String, dynamic> json) {
    return GeographicalCoverage(
      districts: (json['districts'] as List?)?.cast<String>() ?? [],
      blocks: (json['blocks'] as List?)?.cast<String>() ?? [],
      coverageArea: json['coverage_area'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'districts': districts,
      'blocks': blocks,
      'coverage_area': coverageArea,
    };
  }
}

class TechnicalExpertise {
  final List<String> specializations;
  final List<String> certifications;
  final int experienceYears;
  final List<String> technologies;
  final int teamSize;

  TechnicalExpertise({
    required this.specializations,
    required this.certifications,
    required this.experienceYears,
    required this.technologies,
    required this.teamSize,
  });

  factory TechnicalExpertise.fromJson(Map<String, dynamic> json) {
    return TechnicalExpertise(
      specializations: (json['specializations'] as List?)?.cast<String>() ?? [],
      certifications: (json['certifications'] as List?)?.cast<String>() ?? [],
      experienceYears: json['experience_years'] ?? 0,
      technologies: (json['technologies'] as List?)?.cast<String>() ?? [],
      teamSize: json['team_size'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specializations': specializations,
      'certifications': certifications,
      'experience_years': experienceYears,
      'technologies': technologies,
      'team_size': teamSize,
    };
  }
}

class FinancialCapacity {
  final double annualTurnover;
  final double projectCapacity;
  final String bankGuarantee;
  final String auditorDetails;

  FinancialCapacity({
    required this.annualTurnover,
    required this.projectCapacity,
    required this.bankGuarantee,
    required this.auditorDetails,
  });

  factory FinancialCapacity.fromJson(Map<String, dynamic> json) {
    return FinancialCapacity(
      annualTurnover: (json['annual_turnover'] ?? 0).toDouble(),
      projectCapacity: (json['project_capacity'] ?? 0).toDouble(),
      bankGuarantee: json['bank_guarantee'] ?? '',
      auditorDetails: json['auditor_details'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'annual_turnover': annualTurnover,
      'project_capacity': projectCapacity,
      'bank_guarantee': bankGuarantee,
      'auditor_details': auditorDetails,
    };
  }
}

class ProjectExperience {
  final String projectName;
  final String clientName;
  final double projectValue;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String performanceRating;

  ProjectExperience({
    required this.projectName,
    required this.clientName,
    required this.projectValue,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.performanceRating,
  });

  factory ProjectExperience.fromJson(Map<String, dynamic> json) {
    return ProjectExperience(
      projectName: json['project_name'] ?? '',
      clientName: json['client_name'] ?? '',
      projectValue: (json['project_value'] ?? 0).toDouble(),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(),
      description: json['description'] ?? '',
      performanceRating: json['performance_rating'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_name': projectName,
      'client_name': clientName,
      'project_value': projectValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'description': description,
      'performance_rating': performanceRating,
    };
  }
}

class KeyPersonnel {
  final String name;
  final String designation;
  final String qualification;
  final int experienceYears;
  final String expertise;

  KeyPersonnel({
    required this.name,
    required this.designation,
    required this.qualification,
    required this.experienceYears,
    required this.expertise,
  });

  factory KeyPersonnel.fromJson(Map<String, dynamic> json) {
    return KeyPersonnel(
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      qualification: json['qualification'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      expertise: json['expertise'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'qualification': qualification,
      'experience_years': experienceYears,
      'expertise': expertise,
    };
  }
}

class VerificationChecklist {
  final bool registrationVerified;
  final bool documentsVerified;
  final bool financialVerified;
  final bool technicalVerified;
  final bool experienceVerified;
  final String verifierNotes;

  VerificationChecklist({
    required this.registrationVerified,
    required this.documentsVerified,
    required this.financialVerified,
    required this.technicalVerified,
    required this.experienceVerified,
    required this.verifierNotes,
  });

  factory VerificationChecklist.fromJson(Map<String, dynamic> json) {
    return VerificationChecklist(
      registrationVerified: json['registration_verified'] ?? false,
      documentsVerified: json['documents_verified'] ?? false,
      financialVerified: json['financial_verified'] ?? false,
      technicalVerified: json['technical_verified'] ?? false,
      experienceVerified: json['experience_verified'] ?? false,
      verifierNotes: json['verifier_notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_verified': registrationVerified,
      'documents_verified': documentsVerified,
      'financial_verified': financialVerified,
      'technical_verified': technicalVerified,
      'experience_verified': experienceVerified,
      'verifier_notes': verifierNotes,
    };
  }
}