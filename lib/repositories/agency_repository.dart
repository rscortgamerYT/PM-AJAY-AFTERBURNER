import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/agency.dart';
import '../models/project.dart';

class AgencyRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Agency>> getAgencies() async {
    try {
      final response = await _supabase
          .from('agencies')
          .select()
          .order('created_at', ascending: false);
      
      return response.map((json) => Agency.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load agencies: $e');
    }
  }

  Future<Agency> getAgency(String id) async {
    try {
      final response = await _supabase
          .from('agencies')
          .select()
          .eq('id', id)
          .single();
      
      return Agency.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load agency: $e');
    }
  }

  Future<List<Agency>> getAgenciesByState(String stateCode) async {
    try {
      final response = await _supabase
          .from('agencies')
          .select()
          .eq('state_code', stateCode)
          .eq('is_active', true)
          .order('name');
      
      return response.map((json) => Agency.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load agencies by state: $e');
    }
  }

  Future<List<Agency>> getAgenciesByCapability(ProjectComponent component) async {
    try {
      final response = await _supabase
          .from('agencies')
          .select()
          .contains('capabilities', [component.toDbString()])
          .eq('is_active', true)
          .order('rating', ascending: false);
      
      return response.map((json) => Agency.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load agencies by capability: $e');
    }
  }

  Future<Agency> createAgency(Agency agency) async {
    try {
      final response = await _supabase
          .from('agencies')
          .insert(agency.toJson())
          .select()
          .single();
      
      return Agency.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create agency: $e');
    }
  }

  Future<Agency> updateAgency(Agency agency) async {
    try {
      final response = await _supabase
          .from('agencies')
          .update(agency.toJson())
          .eq('id', agency.id)
          .select()
          .single();
      
      return Agency.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update agency: $e');
    }
  }

  Future<void> deleteAgency(String id) async {
    try {
      await _supabase
          .from('agencies')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete agency: $e');
    }
  }

  Stream<List<Agency>> watchAgencies() {
    return _supabase
        .from('agencies')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Agency.fromJson(json)).toList());
  }

  Future<Map<String, dynamic>> getAgencyPerformanceStats(String agencyId) async {
    try {
      final response = await _supabase
          .rpc('get_agency_performance_stats', params: {
            'agency_id': agencyId,
          });
      
      return response;
    } catch (e) {
      throw Exception('Failed to get agency performance stats: $e');
    }
  }

  Future<List<Agency>> searchAgencies(String query) async {
    try {
      final response = await _supabase
          .from('agencies')
          .select()
          .or('name.ilike.%$query%,registration_number.ilike.%$query%')
          .eq('is_active', true)
          .order('name');
      
      return response.map((json) => Agency.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search agencies: $e');
    }
  }
}
