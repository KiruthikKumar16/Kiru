import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, String>> _chats = const [
    {
      'id': 'c1',
      'name': 'Marcus Chen',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop',
      'lastMsg': 'Loved your linen jacket recommendation! Packed it.',
      'time': '10:42 AM',
      'unread': '2',
    },
    {
      'id': 'c2',
      'name': 'Sophie Miller',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop',
      'lastMsg': 'Are you sharing the Paris packing list?',
      'time': 'Yesterday',
      'unread': '0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Messages', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: _chats.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final chat = _chats[index];
            final hasUnread = chat['unread'] != '0';

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chat['avatar']!),
                radius: 24,
              ),
              title: Text(chat['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(chat['lastMsg']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(chat['time']!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  if (hasUnread) ...[
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.primary,
                      child: Text(chat['unread']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              onTap: () => context.push('/messages/${chat['id']}'),
            );
          },
        ),
      ),
    );
  }
}
