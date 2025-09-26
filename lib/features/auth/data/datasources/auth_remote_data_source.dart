import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final docRef = firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        username: user.displayName ?? user.email?.split('@')[0],
        avatarUrl: user.photoURL,
        fcmToken: null,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        status: null,
      );
      await docRef.set(newUser.toJson());
      return newUser;
    }
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception("Sign in failed");

    final docRef = firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        username: user.displayName ?? user.email?.split('@')[0],
        avatarUrl: user.photoURL,
        fcmToken: null,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        status: null,
      );
      await docRef.set(newUser.toJson());
      return newUser;
    }
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) throw Exception("Sign up failed");

    final newUser = UserModel(
      uid: uid,
      email: email,
      username: email.split('@')[0],
      avatarUrl: null,
      fcmToken: null,
      lastSeen: DateTime.now().millisecondsSinceEpoch,
      status: null,
    );

    await firestore.collection('users').doc(uid).set(newUser.toJson());

    return newUser;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
