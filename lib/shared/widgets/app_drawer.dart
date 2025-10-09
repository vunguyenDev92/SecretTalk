import 'chat_list_tile.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onSignOut;
  final String? userName;
  final String? avatarUrl;

  const AppDrawer({super.key, this.onSignOut, this.userName, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        (avatarUrl != null && avatarUrl!.isNotEmpty)
                        ? NetworkImage(avatarUrl!) as ImageProvider
                        : AssetImage(kDefaultAvatarAsset),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    userName ?? 'Guest',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('New Direct Message'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('New Group'),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}
