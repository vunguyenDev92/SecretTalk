import 'package:flutter/material.dart';

const String kDefaultAvatarAsset = 'assets/avatar.png';

class ChatListTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final VoidCallback? onTap;
  const ChatListTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(kDefaultAvatarAsset)),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Text(time),
      onTap: onTap,
    );
  }
}
