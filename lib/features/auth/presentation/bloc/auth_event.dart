import '../../domain/entities/user_entity.dart';

abstract class AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInRequested(this.email, this.password);
}

class AuthSignUpRequested extends AuthEvent {
  final UserEntity user;
  final String password;
  AuthSignUpRequested(this.user, this.password);
}

class AuthSignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
