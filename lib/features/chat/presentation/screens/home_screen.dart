import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app_chat/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app_chat/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_app_chat/shared/widgets/app_drawer.dart';
import 'package:flutter_app_chat/shared/widgets/chat_list_empty.dart';
import 'package:flutter_app_chat/shared/widgets/chat_list_tile.dart';
import 'package:flutter_app_chat/shared/widgets/confirm_dialog.dart';

import 'package:flutter_app_chat/features/auth/presentation/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> chats = [];

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => const ConfirmDialog(
        title: 'Sign Out',
        content: 'Are you sure you want to sign out?',
        confirmText: 'Sign Out',
        cancelText: 'Cancel',
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      context.read<AuthBloc>().add(AuthSignOutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        drawer: AppDrawer(onSignOut: _handleSignOut, userName: 'Andrew Jones'),
        appBar: AppBar(
          title: const Text('Secret Chat'),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: CircleAvatar(
                backgroundImage: AssetImage(kDefaultAvatarAsset),
                radius: 16,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
        ),
        body: _selectedIndex == 0 ? _buildChatList() : _buildMentions(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alternate_email),
              label: 'Mentions',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    if (chats.isEmpty) {
      return ChatListEmpty(onStartChat: () {});
    }
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatListTile(
          name: chat['name'] ?? '',
          lastMessage: chat['lastMessage'] ?? '',
          time: chat['time'] ?? '',
          onTap: () {},
        );
      },
    );
  }

  Widget _buildMentions() {
    return const Center(child: Text('Mentions'));
  }
}
