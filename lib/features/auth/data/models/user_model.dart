import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.username,
    super.avatarUrl,
    super.fcmToken,
    super.lastSeen,
    super.status,
    super.phoneNumber,
    super.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      fcmToken: json['fcmToken'] as String?,
      lastSeen: json['lastSeen'] as int?,
      status: json['status'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      birthDate: json['birthDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'fcmToken': fcmToken,
      'lastSeen': lastSeen,
      'status': status,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    };
  }
}
