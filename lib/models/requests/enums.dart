import 'package:flutter/material.dart';

// State Request Types
enum StateRequestType {
  fundAllocation('fund_allocation', 'Fund Allocation'),
  schemeExpansion('scheme_expansion', 'Scheme Expansion'),
  policyClarification('policy_clarification', 'Policy Clarification'),
  technicalSupport('technical_support', 'Technical Support');

  final String value;
  final String displayName;

  const StateRequestType(this.value, this.displayName);

  static StateRequestType fromString(String value) {
    return StateRequestType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => StateRequestType.fundAllocation,
    );
  }
}

// Priority Levels
enum PriorityLevel {
  high('high', 'High', Colors.red),
  medium('medium', 'Medium', Colors.orange),
  low('low', 'Low', Colors.green);

  final String value;
  final String displayName;
  final Color color;

  const PriorityLevel(this.value, this.displayName, this.color);

  static PriorityLevel fromString(String value) {
    return PriorityLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => PriorityLevel.medium,
    );
  }
}

// Request Status
enum RequestStatus {
  submitted('submitted', 'Submitted', Colors.blue),
  underReview('under_review', 'Under Review', Colors.orange),
  approved('approved', 'Approved', Colors.green),
  rejected('rejected', 'Rejected', Colors.red),
  revisionRequired('revision_required', 'Revision Required', Colors.amber),
  moreInfoRequired('more_info_required', 'More Info Required', Colors.purple),
  documentVerification('document_verification', 'Document Verification', Colors.teal);

  final String value;
  final String displayName;
  final Color color;

  const RequestStatus(this.value, this.displayName, this.color);

  static RequestStatus fromString(String value) {
    return RequestStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => RequestStatus.submitted,
    );
  }
}

// Scheme Components (Public Request Types)
enum SchemeComponent {
  adarshGram('adarsh_gram', 'Adarsh Gram'),
  hostel('hostel', 'Hostel'),
  gia('gia', 'Grant-in-Aid (GIA)');

  final String value;
  final String displayName;

  const SchemeComponent(this.value, this.displayName);

  static SchemeComponent fromString(String value) {
    return SchemeComponent.values.firstWhere(
      (component) => component.value == value,
      orElse: () => SchemeComponent.adarshGram,
    );
  }
}

// Agency Types
enum AgencyType {
  government('government', 'Government'),
  psu('psu', 'PSU'),
  private('private', 'Private'),
  ngo('ngo', 'NGO');

  final String value;
  final String displayName;

  const AgencyType(this.value, this.displayName);

  static AgencyType fromString(String value) {
    return AgencyType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AgencyType.government,
    );
  }
}