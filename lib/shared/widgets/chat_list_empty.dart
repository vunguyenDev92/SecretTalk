import 'package:flutter/material.dart';

class ChatListEmpty extends StatelessWidget {
  final VoidCallback? onStartChat;
  const ChatListEmpty({super.key, this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Let's start chatting!", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onStartChat,
            child: const Text(
              'Start a chat',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
