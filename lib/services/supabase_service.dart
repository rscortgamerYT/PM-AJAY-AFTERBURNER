import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  // Centre Admin RPCs
  static Future<Map<String, dynamic>> getCentreBudget() async {
    final response = await _client.rpc('get_centre_budget');
    return response as Map<String, dynamic>;
  }
  
  static Future<Map<String, dynamic>> getStatePerformance() async {
    final response = await _client.rpc('get_state_performance');
    return response as Map<String, dynamic>;
  }
  
  static Future<List<dynamic>> getFundFlow() async {
    final response = await _client.rpc('get_fund_flow');
    return response as List<dynamic>;
  }
  
  static Future<void> approveStateRequest(String id, String userId) async {
    await _client.rpc('approve_state_request', params: {
      'request_id': id,
      'approver_id': userId,
    });
  }
  
  static Future<void> rejectStateRequest(String id, String reason) async {
    await _client.rpc('reject_state_request', params: {
      'request_id': id,
      'rejection_reason': reason,
    });
  }
  
  static Future<void> holdStateRequest(String id, String notes) async {
    await _client.rpc('hold_state_request', params: {
      'request_id': id,
      'hold_notes': notes,
    });
  }
  
  static Future<void> resolveAlert(String id) async {
    await _client.rpc('resolve_alert', params: {'alert_id': id});
  }
  
  static Future<Map<String, dynamic>> getAnalyticsStatePerformance() async {
    final response = await _client.rpc('analytics_state_performance');
    return response as Map<String, dynamic>;
  }
  
  // State Officer RPCs
  static Future<void> approvePublicRequest(String id, String notes, int score) async {
    await _client.rpc('approve_public_request', params: {
      'request_id': id,
      'approval_notes': notes,
      'quality_score': score,
    });
  }
  
  static Future<void> rejectPublicRequest(String id, String notes) async {
    await _client.rpc('reject_public_request', params: {
      'request_id': id,
      'rejection_notes': notes,
    });
  }
  
  static Future<void> approveAgencyRequest(String id) async {
    await _client.rpc('approve_agency_request', params: {'request_id': id});
  }
  
  static Future<void> rejectAgencyRequest(String id, String notes) async {
    await _client.rpc('reject_agency_request', params: {
      'request_id': id,
      'rejection_notes': notes,
    });
  }
  
  static Future<void> assignProject(String projectId, String agencyId) async {
    await _client.rpc('assign_project', params: {
      'project_id': projectId,
      'agency_id': agencyId,
    });
  }
  
  static Future<String> createFundTransfer(String stateCode, double amount, DateTime date) async {
    final response = await _client.rpc('create_fund_transfer', params: {
      'state_code': stateCode,
      'transfer_amount': amount,
      'scheduled_date': date.toIso8601String(),
    });
    return response as String;
  }
  
  static Future<void> confirmStateReceipt(String transferId, String signature) async {
    await _client.rpc('confirm_state_receipt', params: {
      'transfer_id': transferId,
      'digital_signature': signature,
    });
  }
  
  static Future<Map<String, dynamic>> getStateAnalytics(String stateCode) async {
    final response = await _client.rpc('get_state_analytics', params: {
      'state_code': stateCode,
    });
    return response as Map<String, dynamic>;
  }
  
  // Agency User RPCs
  static Future<void> acceptAssignment(String id, String signature) async {
    await _client.rpc('accept_assignment', params: {
      'assignment_id': id,
      'digital_signature': signature,
    });
  }
  
  static Future<void> rejectAssignment(String id, String reason) async {
    await _client.rpc('reject_assignment', params: {
      'assignment_id': id,
      'rejection_reason': reason,
    });
  }
  
  static Future<void> submitProgress(String projectId, Map<String, dynamic> data) async {
    await _client.rpc('submit_progress', params: {
      'project_id': projectId,
      'progress_data': data,
    });
  }
  
  static Future<List<dynamic>> getAgencyProjects(String agencyId) async {
    final response = await _client.rpc('get_agency_projects', params: {
      'agency_id': agencyId,
    });
    return response as List<dynamic>;
  }
  
  static Future<void> updateAgencyRequestDocs(String id, List<String> docs) async {
    await _client.rpc('update_agency_request_docs', params: {
      'request_id': id,
      'document_urls': docs,
    });
  }
  
  static Future<void> updateAgencyProfile(String agencyId, Map<String, dynamic> profile) async {
    await _client.rpc('update_agency_profile', params: {
      'agency_id': agencyId,
      'profile_data': profile,
    });
  }
  
  // Auditor RPCs
  static Future<Map<String, dynamic>> getAuditRisk() async {
    final response = await _client.rpc('get_audit_risk');
    return response as Map<String, dynamic>;
  }
  
  static Future<void> flagTransfer(String id, String reason) async {
    await _client.rpc('flag_transfer', params: {
      'transfer_id': id,
      'flag_reason': reason,
    });
  }
  
  static Future<void> auditEvidence(String id, String status, String notes) async {
    await _client.rpc('audit_evidence', params: {
      'evidence_id': id,
      'audit_status': status,
      'audit_notes': notes,
    });
  }
  
  static Future<void> updateCompliance(String milestoneId, String status) async {
    await _client.rpc('update_compliance', params: {
      'milestone_id': milestoneId,
      'compliance_status': status,
    });
  }
  
  static Future<void> resolveFlag(String id, String actionTaken) async {
    await _client.rpc('resolve_flag', params: {
      'flag_id': id,
      'resolution_action': actionTaken,
    });
  }
  
  // Public Portal RPCs
  static Future<List<dynamic>> getPublicProjects(Map<String, dynamic> filters) async {
    final response = await _client.rpc('get_public_projects', params: {
      'filter_params': filters,
    });
    return response as List<dynamic>;
  }
  
  static Future<String> createPublicRequest(Map<String, dynamic> data) async {
    final response = await _client.rpc('create_public_request', params: {
      'request_data': data,
    });
    return response as String;
  }
  
  static Future<String> createPublicPost(Map<String, dynamic> data) async {
    final response = await _client.rpc('create_public_post', params: {
      'post_data': data,
    });
    return response as String;
  }
  
  // Communication Hub RPCs
  static Future<String> createChatRoom(Map<String, dynamic> data) async {
    final response = await _client.rpc('create_chat_room', params: {
      'room_data': data,
    });
    return response as String;
  }
  
  static Future<void> markNotificationsRead(String userId) async {
    await _client.rpc('mark_notifications_read', params: {
      'user_id': userId,
    });
  }
  
  // Storage operations
  static Future<String> uploadFile(String bucket, String path, List<int> fileBytes) async {
    await _client.storage.from(bucket).uploadBinary(path, fileBytes);
    return _client.storage.from(bucket).getPublicUrl(path);
  }
  
  static Future<List<int>> downloadFile(String bucket, String path) async {
    return await _client.storage.from(bucket).download(path);
  }
  
  // Real-time subscriptions
  static RealtimeChannel subscribeToTable(String table, void Function(PostgresChangePayload) callback) {
    return _client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
  }
  
  static RealtimeChannel subscribeToUserNotifications(String userId, void Function(PostgresChangePayload) callback) {
    return _client
        .channel('user_notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'recipient_id',
            value: userId,
          ),
          callback: callback,
        )
        .subscribe();
  }
  
  // Database queries
  static Future<List<Map<String, dynamic>>> query(String table, {
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    var query = _client.from(table).select(select ?? '*');
    
    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }
    
    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<Map<String, dynamic>?> queryOne(String table, {
    String? select,
    Map<String, dynamic>? filters,
  }) async {
    var query = _client.from(table).select(select ?? '*');
    
    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }
    
    final response = await query.single();
    return response;
  }
  
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    await _client.from(table).insert(data);
  }
  
  static Future<void> update(String table, Map<String, dynamic> data, Map<String, dynamic> filters) async {
    var query = _client.from(table).update(data);
    
    filters.forEach((key, value) {
      query = query.eq(key, value);
    });
    
    await query;
  }
  
  static Future<void> delete(String table, Map<String, dynamic> filters) async {
    var query = _client.from(table).delete();
    
    filters.forEach((key, value) {
      query = query.eq(key, value);
    });
    
    await query;
  }
}
