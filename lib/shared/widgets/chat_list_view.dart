import 'package:flutter/material.dart';
import 'optimized_chat_list_tile.dart';

typedef ChatTapCallback = void Function(String id);

class ChatListView extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final ChatTapCallback? onTap;
  final RefreshCallback? onRefresh;
  final double? itemExtent;

  const ChatListView({
    super.key,
    required this.items,
    this.onTap,
    this.onRefresh,
    this.itemExtent = 76,
  });

  @override
  Widget build(BuildContext context) {
    // Use RefreshIndicator for pull-to-refresh UX
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            height: itemExtent,
            child: OptimizedChatListTile(
              id: item['id'] ?? index.toString(),
              name: item['name'] ?? '',
              lastMessage: item['lastMessage'] ?? '',
              time: item['time'] ?? '',
              avatarUrl: item['avatarUrl'],
              unreadCount: item['unreadCount'] ?? 0,
              isOnline: item['isOnline'] ?? false,
              onTap: () => onTap?.call(item['id'] ?? index.toString()),
            ),
          );
        },
      ),
    );
  }
}
