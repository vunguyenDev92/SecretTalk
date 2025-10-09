import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app_chat/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app_chat/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_app_chat/shared/widgets/app_drawer.dart';
import 'package:flutter_app_chat/shared/widgets/chat_list_empty.dart';
import 'package:flutter_app_chat/shared/widgets/chat_list_view.dart';
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
  final List<Map<String, dynamic>> chats = [
    {
      'id': '1',
      'name': 'Daniel Atkins',
      'lastMessage': 'The weather will be perfect for the stream tonight',
      'time': '2:14 PM',
      'avatarUrl': null,
      'unreadCount': 1,
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Erin, Ursula, Matthew',
      'lastMessage': 'You: The store only has (gasp!) 2% milk left',
      'time': '2:14 PM',
      'avatarUrl': null,
      'unreadCount': 1,
    },
    {
      'id': '3',
      'name': 'Photographers',
      'lastMessage': '@Philippe: Hmm, are you sure?',
      'time': '10:16 PM',
      'avatarUrl': null,
      'unreadCount': 80,
    },
    {
      'id': '4',
      'name': 'Nelms, Clayton, Wagner, Morgan',
      'lastMessage': 'You: The game went into OT, it\'s gonna be wild',
      'time': 'Friday',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '5',
      'name': 'Regina Jones',
      'lastMessage': 'The class has open enrollment until the end of the month',
      'time': '12/28/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '6',
      'name': 'Baker Hayfield',
      'lastMessage': '@waldo Is Cleveland nice in October?',
      'time': '08/09/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '7',
      'name': 'Kaitlyn Henson',
      'lastMessage': 'You: Can you mail my rent check?',
      'time': '22/08/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '8',
      'name': 'Kaitlyn Henson',
      'lastMessage': 'You: Can you mail my rent check?',
      'time': '22/08/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '8',
      'name': 'Kaitlyn Henson',
      'lastMessage': 'You: Can you mail my rent check?',
      'time': '22/08/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '8',
      'name': 'Kaitlyn Henson',
      'lastMessage': 'You: Can you mail my rent check?',
      'time': '22/08/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '8',
      'name': 'Kaitlyn Henson',
      'lastMessage': 'You: Can you mail my rent check?',
      'time': '22/08/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
    {
      'id': '8',
      'name': 'Kaitlyn Henson',
      'lastMessage': 'You: Can you mail my rent check?',
      'time': '22/08/20',
      'avatarUrl': null,
      'unreadCount': 0,
    },
  ];

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
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String? userName;
          String? avatarUrl;
          if (state is AuthAuthenticated) {
            userName = state.user.username ?? state.user.email;
            avatarUrl = state.user.avatarUrl;
          }

          return Scaffold(
            drawer: AppDrawer(
              onSignOut: _handleSignOut,
              userName: userName,
              avatarUrl: avatarUrl,
            ),
            appBar: AppBar(
              title: const Text('Secret Chat'),
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: CircleAvatar(
                    backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? NetworkImage(avatarUrl)
                        : AssetImage(kDefaultAvatarAsset) as ImageProvider,
                    radius: 16,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ],
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
          );
        },
      ),
    );
  }

  Widget _buildChatList() {
    if (chats.isEmpty) return ChatListEmpty(onStartChat: () {});

    return ChatListView(
      items: chats,
      onTap: (id) {
        // TODO: navigate to chat screen for id
      },
      onRefresh: () async {
        // TODO: implement refresh logic; for demo, delay briefly
        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }

  Widget _buildMentions() {
    return const Center(child: Text('Mentions'));
  }
}
