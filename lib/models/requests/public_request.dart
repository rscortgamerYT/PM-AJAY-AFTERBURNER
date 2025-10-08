import 'package:pmajay_app/models/requests/document_reference.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class PublicRequest {
  final String id;
  final String stateCode;
  final String district;
  final String block;
  final String village;
  final SchemeComponent requestType;
  final String title;
  final String description;
  final int? beneficiaryCount;
  final List<DocumentReference> supportingDocuments;
  final CitizenDetails citizenDetails;
  final VillageDetails villageDetails;
  final RequestStatus status;
  final String? stateReviewerId;
  final String? stateReviewNotes;
  final int priorityScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reviewedAt;

  PublicRequest({
    required this.id,
    required this.stateCode,
    required this.district,
    required this.block,
    required this.village,
    required this.requestType,
    required this.title,
    required this.description,
    this.beneficiaryCount,
    required this.supportingDocuments,
    required this.citizenDetails,
    required this.villageDetails,
    required this.status,
    this.stateReviewerId,
    this.stateReviewNotes,
    required this.priorityScore,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedAt,
  });

  factory PublicRequest.fromJson(Map<String, dynamic> json) {
    return PublicRequest(
      id: json['id'] ?? '',
      stateCode: json['state_code'] ?? '',
      district: json['district'] ?? '',
      block: json['block'] ?? '',
      village: json['village'] ?? '',
      requestType: SchemeComponent.fromString(json['request_type'] ?? 'adarsh_gram'),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      beneficiaryCount: json['beneficiary_count'],
      supportingDocuments: (json['supporting_documents'] as List?)
              ?.map((doc) => DocumentReference.fromJson(doc))
              .toList() ??
          [],
      citizenDetails: CitizenDetails.fromJson(json['citizen_details'] ?? {}),
      villageDetails: VillageDetails.fromJson(json['village_details'] ?? {}),
      status: RequestStatus.fromString(json['status'] ?? 'submitted'),
      stateReviewerId: json['state_reviewer_id'],
      stateReviewNotes: json['state_review_notes'],
      priorityScore: json['priority_score'] ?? 0,
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
      'district': district,
      'block': block,
      'village': village,
      'request_type': requestType.value,
      'title': title,
      'description': description,
      'beneficiary_count': beneficiaryCount,
      'supporting_documents': supportingDocuments.map((doc) => doc.toJson()).toList(),
      'citizen_details': citizenDetails.toJson(),
      'village_details': villageDetails.toJson(),
      'status': status.value,
      'state_reviewer_id': stateReviewerId,
      'state_review_notes': stateReviewNotes,
      'priority_score': priorityScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }
}

class CitizenDetails {
  final String name;
  final String fatherName;
  final String email;
  final String phone;
  final String address;
  final String aadharNumber;
  final String category;

  CitizenDetails({
    required this.name,
    required this.fatherName,
    required this.email,
    required this.phone,
    required this.address,
    required this.aadharNumber,
    required this.category,
  });

  factory CitizenDetails.fromJson(Map<String, dynamic> json) {
    return CitizenDetails(
      name: json['name'] ?? '',
      fatherName: json['father_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      aadharNumber: json['aadhar_number'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'father_name': fatherName,
      'email': email,
      'phone': phone,
      'address': address,
      'aadhar_number': aadharNumber,
      'category': category,
    };
  }
}

class VillageDetails {
  final String population;
  final String scPopulation;
  final String stPopulation;
  final String currentFacilities;
  final String nearestCity;
  final String distanceFromCity;

  VillageDetails({
    required this.population,
    required this.scPopulation,
    required this.stPopulation,
    required this.currentFacilities,
    required this.nearestCity,
    required this.distanceFromCity,
  });

  factory VillageDetails.fromJson(Map<String, dynamic> json) {
    return VillageDetails(
      population: json['population'] ?? '',
      scPopulation: json['sc_population'] ?? '',
      stPopulation: json['st_population'] ?? '',
      currentFacilities: json['current_facilities'] ?? '',
      nearestCity: json['nearest_city'] ?? '',
      distanceFromCity: json['distance_from_city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'population': population,
      'sc_population': scPopulation,
      'st_population': stPopulation,
      'current_facilities': currentFacilities,
      'nearest_city': nearestCity,
      'distance_from_city': distanceFromCity,
    };
  }
}