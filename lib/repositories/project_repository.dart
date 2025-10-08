import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/project.dart';
import '../models/milestone.dart';

class ProjectRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Project>> getProjects() async {
    try {
      final response = await _supabase
          .from('projects')
          .select('''
            *,
            milestones(*)
          ''')
          .order('created_at', ascending: false);
      
      return response.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<Project> getProject(String id) async {
    try {
      final response = await _supabase
          .from('projects')
          .select('''
            *,
            milestones(*)
          ''')
          .eq('id', id)
          .single();
      
      return Project.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load project: $e');
    }
  }

  Future<Project> createProject(Project project) async {
    try {
      final response = await _supabase
          .from('projects')
          .insert(project.toJson())
          .select()
          .single();
      
      return Project.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<Project> updateProject(Project project) async {
    try {
      final response = await _supabase
          .from('projects')
          .update(project.toJson())
          .eq('id', project.id)
          .select()
          .single();
      
      return Project.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _supabase
          .from('projects')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  Stream<List<Project>> watchProjects() {
    return _supabase
        .from('projects')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Project.fromJson(json)).toList());
  }

  Future<List<Project>> getProjectsByState(String stateCode) async {
    try {
      final response = await _supabase
          .from('projects')
          .select('''
            *,
            milestones(*)
          ''')
          .eq('state_code', stateCode)
          .order('created_at', ascending: false);
      
      return response.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load projects by state: $e');
    }
  }

  Future<List<Project>> getProjectsByAgency(String agencyId) async {
    try {
      final response = await _supabase
          .from('projects')
          .select('''
            *,
            milestones(*)
          ''')
          .eq('agency_id', agencyId)
          .order('created_at', ascending: false);
      
      return response.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load projects by agency: $e');
    }
  }

  Future<List<Project>> getProjectsByComponent(ProjectComponent component) async {
    try {
      final response = await _supabase
          .from('projects')
          .select('''
            *,
            milestones(*)
          ''')
          .eq('component', component.toDbString())
          .order('created_at', ascending: false);
      
      return response.map((json) => Project.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load projects by component: $e');
    }
  }

  Future<Milestone> createMilestone(Milestone milestone) async {
    try {
      final response = await _supabase
          .from('milestones')
          .insert(milestone.toJson())
          .select()
          .single();
      
      return Milestone.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create milestone: $e');
    }
  }

  Future<Milestone> updateMilestone(Milestone milestone) async {
    try {
      final response = await _supabase
          .from('milestones')
          .update(milestone.toJson())
          .eq('id', milestone.id)
          .select()
          .single();
      
      return Milestone.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update milestone: $e');
    }
  }

  Future<void> deleteMilestone(String id) async {
    try {
      await _supabase
          .from('milestones')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete milestone: $e');
    }
  }
}
