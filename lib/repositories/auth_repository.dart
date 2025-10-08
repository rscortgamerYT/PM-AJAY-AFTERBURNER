import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserRole?> getUserRole(String userId) async {
    try {
      final response = await _supabase
          .from('user_roles')
          .select()
          .eq('user_id', userId)
          .single();
      
      return UserRole.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserRole> createUserRole({
    required String userId,
    required UserRoleType roleType,
    String? stateCode,
    String? agencyId,
  }) async {
    final response = await _supabase
        .from('user_roles')
        .insert({
          'user_id': userId,
          'role_type': roleType.toDbString(),
          'state_code': stateCode,
          'agency_id': agencyId,
        })
        .select()
        .single();
    
    return UserRole.fromJson(response);
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> updateProfile({
    String? displayName,
    Map<String, dynamic>? data,
  }) async {
    final updates = <String, dynamic>{};
    
    if (displayName != null) {
      updates['display_name'] = displayName;
    }
    
    if (data != null) {
      updates.addAll(data);
    }

    await _supabase.auth.updateUser(
      UserAttributes(data: updates),
    );
  }
}
