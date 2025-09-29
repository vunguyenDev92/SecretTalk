import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onSignOut;
  const AppDrawer({super.key, this.onSignOut});

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
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Andrew Jones',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
