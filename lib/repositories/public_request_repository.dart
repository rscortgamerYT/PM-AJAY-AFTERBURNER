import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pmajay_app/models/requests/public_request.dart';
import 'package:pmajay_app/models/requests/enums.dart';

class PublicRequestRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Public submits request to State
  Future<PublicRequest> submitPublicRequest(PublicRequest request) async {
    final response = await _supabase
        .from('public_requests')
        .insert({
          'state_code': request.stateCode,
          'district': request.district,
          'block': request.block,
          'village': request.village,
          'request_type': request.requestType.value,
          'title': request.title,
          'description': request.description,
          'beneficiary_count': request.beneficiaryCount,
          'supporting_documents': request.supportingDocuments.map((doc) => doc.toJson()).toList(),
          'citizen_details': request.citizenDetails.toJson(),
          'village_details': request.villageDetails.toJson(),
        })
        .select()
        .single();

    // Send notification to State officers
    await _sendNotificationToStateOfficers(response['id'], request.stateCode, request.title);
    
    return PublicRequest.fromJson(response);
  }

  // Get single public request
  Future<PublicRequest> getPublicRequest(String requestId) async {
    final response = await _supabase
        .from('public_requests')
        .select()
        .eq('id', requestId)
        .single();

    return PublicRequest.fromJson(response);
  }

  // State reviews public request
  Future<void> reviewPublicRequest(
    String requestId,
    RequestStatus status,
    String reviewNotes,
    int priorityScore,
  ) async {
    await _supabase
        .from('public_requests')
        .update({
          'status': status.value,
          'state_review_notes': reviewNotes,
          'priority_score': priorityScore,
          'state_reviewer_id': _supabase.auth.currentUser?.id,
          'reviewed_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);

    // Send notification to citizen
    final request = await getPublicRequest(requestId);
    await _sendNotificationToCitizen(request, status, reviewNotes);
  }

  // Send notification to State officers
  Future<void> _sendNotificationToStateOfficers(
    String requestId,
    String stateCode,
    String title,
  ) async {
    // Get state officers
    final stateOfficers = await _supabase
        .from('user_roles')
        .select('user_id')
        .eq('role_type', 'state_officer')
        .eq('state_code', stateCode);

    for (final officer in stateOfficers) {
      await _supabase.from('notifications').insert({
        'recipient_id': officer['user_id'],
        'notification_type': 'public_request_submitted',
        'title': 'New Public Request Submitted',
        'message': 'A citizen has submitted a new request: $title',
        'related_entity_type': 'public_request',
        'related_entity_id': requestId,
        'action_required': true,
        'action_url': '/state/public-requests/$requestId',
      });
    }
  }

  // Send notification to citizen
  Future<void> _sendNotificationToCitizen(
    PublicRequest request,
    RequestStatus status,
    String reviewNotes,
  ) async {
    String message;
    if (status == RequestStatus.approved) {
      message = 'Your request "${request.title}" has been approved. $reviewNotes';
    } else if (status == RequestStatus.rejected) {
      message = 'Your request "${request.title}" has been rejected. Reason: $reviewNotes';
    } else if (status == RequestStatus.moreInfoRequired) {
      message = 'Your request "${request.title}" requires more information. $reviewNotes';
    } else {
      message = 'Your request "${request.title}" is under review. $reviewNotes';
    }

    // Note: In a real implementation, you would send this notification via email/SMS
    // as citizens may not have accounts in the system
    await _supabase.from('notifications').insert({
      'recipient_id': request.citizenDetails.email, // Store email for reference
      'notification_type': 'public_request_reviewed',
      'title': 'Request Review Update',
      'message': message,
      'related_entity_type': 'public_request',
      'related_entity_id': request.id,
      'action_required': status == RequestStatus.moreInfoRequired,
    });
  }

  // Watch public requests (real-time)
  Stream<List<PublicRequest>> watchPublicRequests({String? stateCode}) {
    if (stateCode != null) {
      return _supabase
          .from('public_requests')
          .stream(primaryKey: ['id'])
          .eq('state_code', stateCode)
          .order('created_at', ascending: false)
          .map((data) => data.map((json) => PublicRequest.fromJson(json)).toList());
    }
    
    return _supabase
        .from('public_requests')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => PublicRequest.fromJson(json)).toList());
  }

  // Get public requests list
  Future<List<PublicRequest>> getPublicRequests({
    String? stateCode,
    RequestStatus? status,
    String? district,
  }) async {
    var query = _supabase.from('public_requests').select();

    if (stateCode != null) {
      query = query.eq('state_code', stateCode);
    }

    if (status != null) {
      query = query.eq('status', status.value);
    }

    if (district != null) {
      query = query.eq('district', district);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((json) => PublicRequest.fromJson(json))
        .toList();
  }

  // Update public request
  Future<void> updatePublicRequest(
    String requestId,
    Map<String, dynamic> updates,
  ) async {
    await _supabase
        .from('public_requests')
        .update({
          ...updates,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  // Delete public request
  Future<void> deletePublicRequest(String requestId) async {
    await _supabase
        .from('public_requests')
        .delete()
        .eq('id', requestId);
  }
}