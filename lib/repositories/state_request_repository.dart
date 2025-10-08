import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pmajay_app/models/requests/state_request.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class StateRequestRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // State submits request to Centre
  Future<StateRequest> submitStateRequest(StateRequest request) async {
    final response = await _supabase
        .from('state_requests')
        .insert({
          'state_code': request.stateCode,
          'request_type': request.requestType.value,
          'title': request.title,
          'description': request.description,
          'requested_amount': request.requestedAmount,
          'priority_level': request.priority.value,
          'documents': request.documents.map((doc) => doc.toJson()).toList(),
          'hierarchy_details': request.hierarchyDetails.toJson(),
          'state_officer_details': request.officerDetails.toJson(),
        })
        .select()
        .single();

    // Send notification to Centre Admin
    await _sendNotificationToCentre(response['id'], request.title);
    
    return StateRequest.fromJson(response);
  }

  // Get single state request
  Future<StateRequest> getStateRequest(String requestId) async {
    final response = await _supabase
        .from('state_requests')
        .select()
        .eq('id', requestId)
        .single();

    return StateRequest.fromJson(response);
  }

  // Centre reviews state request
  Future<void> reviewStateRequest(
    String requestId,
    RequestStatus status,
    String reviewNotes, {
    String? approvedGuidelines,
    List<String>? requiredDocuments,
  }) async {
    await _supabase
        .from('state_requests')
        .update({
          'status': status.value,
          'centre_review_notes': reviewNotes,
          'approved_guidelines': approvedGuidelines,
          'required_documents': requiredDocuments,
          'centre_reviewer_id': _supabase.auth.currentUser?.id,
          'reviewed_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);

    // Send notification to State
    final request = await getStateRequest(requestId);
    await _sendNotificationToState(request, status, reviewNotes, approvedGuidelines);
  }

  // Send notification to Centre Admin
  Future<void> _sendNotificationToCentre(String requestId, String title) async {
    // Get Centre Admin users
    final centreAdmins = await _supabase
        .from('user_roles')
        .select('user_id')
        .eq('role_type', 'centre_admin');

    for (final admin in centreAdmins) {
      await _supabase.from('notifications').insert({
        'recipient_id': admin['user_id'],
        'notification_type': 'state_request_submitted',
        'title': 'New State Request Submitted',
        'message': 'State has submitted a new request: $title',
        'related_entity_type': 'state_request',
        'related_entity_id': requestId,
        'action_required': true,
        'action_url': '/centre/requests/$requestId',
      });
    }
  }

  // Send notification to State
  Future<void> _sendNotificationToState(
    StateRequest request,
    RequestStatus status,
    String reviewNotes,
    String? approvedGuidelines,
  ) async {
    // Get state officers
    final stateOfficers = await _supabase
        .from('user_roles')
        .select('user_id')
        .eq('role_type', 'state_officer')
        .eq('state_code', request.stateCode);

    String message;
    if (status == RequestStatus.approved) {
      message = 'Your request "${request.title}" has been approved. $reviewNotes';
    } else if (status == RequestStatus.rejected) {
      message = 'Your request "${request.title}" has been rejected. Reason: $reviewNotes';
    } else {
      message = 'Your request "${request.title}" requires revision. $reviewNotes';
    }

    for (final officer in stateOfficers) {
      await _supabase.from('notifications').insert({
        'recipient_id': officer['user_id'],
        'notification_type': 'state_request_reviewed',
        'title': 'Request Review Update',
        'message': message,
        'related_entity_type': 'state_request',
        'related_entity_id': request.id,
        'action_required': status == RequestStatus.revisionRequired,
        'action_url': '/state/requests/${request.id}',
      });
    }
  }

  // Watch state requests (real-time)
  Stream<List<StateRequest>> watchStateRequests({String? stateCode}) {
    if (stateCode != null) {
      return _supabase
          .from('state_requests')
          .stream(primaryKey: ['id'])
          .eq('state_code', stateCode)
          .order('created_at', ascending: false)
          .map((data) => data.map((json) => StateRequest.fromJson(json)).toList());
    }
    
    return _supabase
        .from('state_requests')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => StateRequest.fromJson(json)).toList());
  }

  // Get state requests list
  Future<List<StateRequest>> getStateRequests({
    String? stateCode,
    RequestStatus? status,
  }) async {
    var query = _supabase.from('state_requests').select();

    if (stateCode != null) {
      query = query.eq('state_code', stateCode);
    }

    if (status != null) {
      query = query.eq('status', status.value);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => StateRequest.fromJson(json))
        .toList();
  }

  // Update state request
  Future<void> updateStateRequest(
    String requestId,
    Map<String, dynamic> updates,
  ) async {
    await _supabase
        .from('state_requests')
        .update({
          ...updates,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  // Delete state request
  Future<void> deleteStateRequest(String requestId) async {
    await _supabase
        .from('state_requests')
        .delete()
        .eq('id', requestId);
  }
}