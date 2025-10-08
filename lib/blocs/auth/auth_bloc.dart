import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<supabase.AuthState>? _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthUserChanged>(_onUserChanged);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    _authSubscription?.cancel();
    _authSubscription = _authRepository.authStateChanges.listen(
      (authState) {
        add(AuthUserChanged(authState.session?.user.id));
      },
    );

    // Check current user
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      add(AuthUserChanged(currentUser.id));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        final userRole = await _authRepository.getUserRole(response.user!.id);
        if (userRole != null) {
          emit(AuthAuthenticated(user: response.user!, userRole: userRole));
        } else {
          emit(const AuthError('User role not found. Please contact administrator.'));
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signUpWithEmail(
        email: event.email,
        password: event.password,
        data: {'display_name': event.displayName},
      );

      if (response.user != null) {
        // Create user role
        final userRole = await _authRepository.createUserRole(
          userId: response.user!.id,
          roleType: event.roleType,
          stateCode: event.stateCode,
          agencyId: event.agencyId,
        );

        emit(AuthAuthenticated(user: response.user!, userRole: userRole));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.userId != null) {
      emit(AuthLoading());
      try {
        final user = _authRepository.currentUser;
        final userRole = await _authRepository.getUserRole(event.userId!);
        
        if (user != null && userRole != null) {
          emit(AuthAuthenticated(user: user, userRole: userRole));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
