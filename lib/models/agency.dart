import 'package:equatable/equatable.dart';
import 'project.dart';

class Agency extends Equatable {
  final String id;
  final String name;
  final String registrationNumber;
  final String stateCode;
  final String districtCode;
  final String contactPerson;
  final String email;
  final String phone;
  final List<ProjectComponent> capabilities;
  final int maxConcurrentCapacity;
  final double rating;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const Agency({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.stateCode,
    required this.districtCode,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.capabilities,
    required this.maxConcurrentCapacity,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    this.metadata,
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registration_number'],
      stateCode: json['state_code'],
      districtCode: json['district_code'],
      contactPerson: json['contact_person'],
      email: json['email'],
      phone: json['phone'],
      capabilities: (json['capabilities'] as List<dynamic>?)
              ?.map((c) => ProjectComponent.fromString(c))
              .toList() ?? [],
      maxConcurrentCapacity: json['max_concurrent_capacity'] ?? 1,
      rating: (json['rating'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'registration_number': registrationNumber,
      'state_code': stateCode,
      'district_code': districtCode,
      'contact_person': contactPerson,
      'email': email,
      'phone': phone,
      'capabilities': capabilities.map((c) => c.toDbString()).toList(),
      'max_concurrent_capacity': maxConcurrentCapacity,
      'rating': rating,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool canHandle(ProjectComponent component) {
    return capabilities.contains(component);
  }

  String get capabilitiesString {
    return capabilities.map((c) => c.displayName).join(', ');
  }

  Agency copyWith({
    String? id,
    String? name,
    String? registrationNumber,
    String? stateCode,
    String? districtCode,
    String? contactPerson,
    String? email,
    String? phone,
    List<ProjectComponent>? capabilities,
    int? maxConcurrentCapacity,
    double? rating,
    bool? isActive,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return Agency(
      id: id ?? this.id,
      name: name ?? this.name,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      stateCode: stateCode ?? this.stateCode,
      districtCode: districtCode ?? this.districtCode,
      contactPerson: contactPerson ?? this.contactPerson,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      capabilities: capabilities ?? this.capabilities,
      maxConcurrentCapacity: maxConcurrentCapacity ?? this.maxConcurrentCapacity,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        registrationNumber,
        stateCode,
        districtCode,
        contactPerson,
        email,
        phone,
        capabilities,
        maxConcurrentCapacity,
        rating,
        isActive,
        createdAt,
        metadata,
      ];
}
