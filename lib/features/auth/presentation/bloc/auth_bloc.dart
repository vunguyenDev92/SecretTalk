import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_event.dart';
import '../state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInUseCase(event.email, event.password);
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
        await signUpUseCase(event.user, event.password);
        final user = await signInUseCase(event.user.email, event.password);
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
        await signOutUseCase();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await getCurrentUserUseCase();
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
