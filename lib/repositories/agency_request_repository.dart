import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pmajay_app/models/requests/agency_request.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class AgencyRequestRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Agency submits registration request
  Future<AgencyRequest> submitAgencyRequest(AgencyRequest request) async {
    final response = await _supabase
        .from('agency_requests')
        .insert({
          'agency_name': request.agencyName,
          'agency_type': request.agencyType.value,
          'state_code': request.stateCode,
          'registration_documents': request.registrationDocuments.map((doc) => doc.toJson()).toList(),
          'geographical_coverage': request.geographicalCoverage.toJson(),
          'technical_expertise': request.technicalExpertise.toJson(),
          'financial_capacity': request.financialCapacity.toJson(),
          'previous_experience': request.previousExperience.map((exp) => exp.toJson()).toList(),
          'key_personnel': request.keyPersonnel.map((person) => person.toJson()).toList(),
          'proposed_components': request.proposedComponents.map((comp) => comp.value).toList(),
        })
        .select()
        .single();

    // Send notification to State Admin
    await _sendNotificationToStateAdmin(response['id'], request.stateCode, request.agencyName);
    
    return AgencyRequest.fromJson(response);
  }

  // Get single agency request
  Future<AgencyRequest> getAgencyRequest(String requestId) async {
    final response = await _supabase
        .from('agency_requests')
        .select()
        .eq('id', requestId)
        .single();

    return AgencyRequest.fromJson(response);
  }

  // State reviews agency request
  Future<void> reviewAgencyRequest(
    String requestId,
    RequestStatus status,
    String reviewNotes,
    VerificationChecklist checklist,
  ) async {
    await _supabase
        .from('agency_requests')
        .update({
          'status': status.value,
          'state_review_notes': reviewNotes,
          'verification_checklist': checklist.toJson(),
          'state_reviewer_id': _supabase.auth.currentUser?.id,
          'reviewed_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);

    // If approved, create agency profile
    if (status == RequestStatus.approved) {
      await _createApprovedAgency(requestId);
    }

    // Send notification to agency
    final request = await getAgencyRequest(requestId);
    await _sendNotificationToAgency(request, status, reviewNotes);
  }

  // Create approved agency profile
  Future<void> _createApprovedAgency(String requestId) async {
    final request = await getAgencyRequest(requestId);
    
    await _supabase.from('agencies').insert({
      'name': request.agencyName,
      'type': request.agencyType.value,
      'state_code': request.stateCode,
      'geographical_coverage': request.geographicalCoverage.toJson(),
      'technical_expertise': request.technicalExpertise.toJson(),
      'financial_capacity': request.financialCapacity.toJson(),
      'key_personnel': request.keyPersonnel.map((person) => person.toJson()).toList(),
      'approved_components': request.proposedComponents.map((comp) => comp.value).toList(),
      'status': 'active',
      'registration_date': DateTime.now().toIso8601String(),
    });
  }

  // Send notification to State Admin
  Future<void> _sendNotificationToStateAdmin(
    String requestId,
    String stateCode,
    String agencyName,
  ) async {
    // Get state admin users
    final stateAdmins = await _supabase
        .from('user_roles')
        .select('user_id')
        .eq('role_type', 'state_admin')
        .eq('state_code', stateCode);

    for (final admin in stateAdmins) {
      await _supabase.from('notifications').insert({
        'recipient_id': admin['user_id'],
        'notification_type': 'agency_request_submitted',
        'title': 'New Agency Registration Request',
        'message': 'Agency "$agencyName" has submitted a registration request',
        'related_entity_type': 'agency_request',
        'related_entity_id': requestId,
        'action_required': true,
        'action_url': '/state/agency-requests/$requestId',
      });
    }
  }

  // Send notification to agency
  Future<void> _sendNotificationToAgency(
    AgencyRequest request,
    RequestStatus status,
    String reviewNotes,
  ) async {
    String message;
    if (status == RequestStatus.approved) {
      message = 'Your agency registration for "${request.agencyName}" has been approved. $reviewNotes';
    } else if (status == RequestStatus.rejected) {
      message = 'Your agency registration for "${request.agencyName}" has been rejected. Reason: $reviewNotes';
    } else if (status == RequestStatus.revisionRequired) {
      message = 'Your agency registration for "${request.agencyName}" requires revision. $reviewNotes';
    } else {
      message = 'Your agency registration for "${request.agencyName}" is under document verification. $reviewNotes';
    }

    // Note: Send notification to agency contact email
    await _supabase.from('notifications').insert({
      'recipient_id': request.id, // Store request ID for reference
      'notification_type': 'agency_request_reviewed',
      'title': 'Agency Registration Update',
      'message': message,
      'related_entity_type': 'agency_request',
      'related_entity_id': request.id,
      'action_required': status == RequestStatus.revisionRequired,
    });
  }

  // Watch agency requests (real-time)
  Stream<List<AgencyRequest>> watchAgencyRequests({String? stateCode}) {
    if (stateCode != null) {
      return _supabase
          .from('agency_requests')
          .stream(primaryKey: ['id'])
          .eq('state_code', stateCode)
          .order('created_at', ascending: false)
          .map((data) => data.map((json) => AgencyRequest.fromJson(json)).toList());
    }
    
    return _supabase
        .from('agency_requests')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => AgencyRequest.fromJson(json)).toList());
  }

  // Get agency requests list
  Future<List<AgencyRequest>> getAgencyRequests({
    String? stateCode,
    RequestStatus? status,
    AgencyType? agencyType,
  }) async {
    var query = _supabase.from('agency_requests').select();

    if (stateCode != null) {
      query = query.eq('state_code', stateCode);
    }

    if (status != null) {
      query = query.eq('status', status.value);
    }

    if (agencyType != null) {
      query = query.eq('agency_type', agencyType.value);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => AgencyRequest.fromJson(json))
        .toList();
  }

  // Update agency request
  Future<void> updateAgencyRequest(
    String requestId,
    Map<String, dynamic> updates,
  ) async {
    await _supabase
        .from('agency_requests')
        .update({
          ...updates,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  // Delete agency request
  Future<void> deleteAgencyRequest(String requestId) async {
    await _supabase
        .from('agency_requests')
        .delete()
        .eq('id', requestId);
  }
}