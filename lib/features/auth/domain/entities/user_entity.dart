// domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? username;
  final String? avatarUrl;
  final String? fcmToken;
  final int? lastSeen;
  final String? status;

  const UserEntity({
    required this.uid,
    required this.email,
    this.username,
    this.avatarUrl,
    this.fcmToken,
    this.lastSeen,
    this.status,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    username,
    avatarUrl,
    fcmToken,
    lastSeen,
    status,
  ];
}
