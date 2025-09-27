import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await remoteDataSource.getCurrentUser();
    return userModel;
  }

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final userModel = await remoteDataSource.signInWithEmail(email, password);
    return userModel;
  }

  @override
  Future<void> signUp(UserEntity user, String password) async {
    await remoteDataSource.signUpWithFullInfo(
      email: user.email,
      password: password,
      username: user.username ?? '',
      phoneNumber: user.phoneNumber,
      birthDate: user.birthDate,
    );
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
