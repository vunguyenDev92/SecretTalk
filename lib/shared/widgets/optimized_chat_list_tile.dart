import 'package:flutter/material.dart';
import 'chat_list_tile.dart';

class OptimizedChatListTile extends StatelessWidget {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String? avatarUrl;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback? onTap;

  const OptimizedChatListTile({
    super.key,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary reduces repaints when parent updates.
    return RepaintBoundary(
      key: ValueKey('chat_tile_\$id'),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 52,
                        height: 52,
                        child: avatarUrl != null && avatarUrl!.isNotEmpty
                            ? FadeInImage.assetNetwork(
                                placeholder: kDefaultAvatarAsset,
                                image: avatarUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                kDefaultAvatarAsset,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Expanded content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Time and unread badge
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
