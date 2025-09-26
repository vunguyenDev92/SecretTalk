import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  String? get username => super.displayName;
  const UserModel({
    required String uid,
    required String email,
    String? username,
    String? avatarUrl,
    String? fcmToken,
    int? lastSeen,
    String? status,
  }) : super(
         uid: uid,
         email: email,
         displayName: username,
         avatarUrl: avatarUrl,
         fcmToken: fcmToken,
         lastSeen: lastSeen,
         status: status,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      fcmToken: json['fcmToken'] as String?,
      lastSeen: json['lastSeen'] as int?,
      status: json['status'] as String?,
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
    };
  }
}
