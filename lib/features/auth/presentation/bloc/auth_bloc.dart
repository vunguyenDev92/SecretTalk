import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import '../state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signIn(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('Sign in failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(event.user, event.password);
        final user = await authRepository.signIn(
          event.user.email,
          event.password,
        );
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('Sign up failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthSignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signOut();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
