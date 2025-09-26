import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> call(UserEntity user, String password) {
    return repository.signUp(user, password);
  }
}
