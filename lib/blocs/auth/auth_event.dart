import 'package:equatable/equatable.dart';
import '../../models/user_role.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  final UserRoleType roleType;
  final String? stateCode;
  final String? agencyId;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
    required this.roleType,
    this.stateCode,
    this.agencyId,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        displayName,
        roleType,
        stateCode,
        agencyId,
      ];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final String? userId;

  const AuthUserChanged(this.userId);

  @override
  List<Object?> get props => [userId];
}
