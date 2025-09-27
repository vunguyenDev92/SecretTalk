import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signIn(String email, String password);
  Future<void> signUp(UserEntity user, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
}
