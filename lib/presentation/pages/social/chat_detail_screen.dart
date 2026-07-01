import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'them', 'text': 'Hey! Did you check out the Kyoto trip outfits recommended by Kiru?'},
    {'sender': 'me', 'text': 'Yes! The AI paired my linen shirt with chinos. Looks super clean!'},
    {'sender': 'them', 'text': 'Loved your linen jacket recommendation! Packed it.'},
  ];

  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add({'sender': 'me', 'text': _controller.text});
      _controller.clear();
    });
  }

  void _showShareOptions() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share to Chat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(Icons.checkroom_outlined, color: AppColors.primary),
                title: const Text('Share Outfit', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Share an outfit from your wardrobe'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share outfit coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.travel_explore_outlined, color: AppColors.primary),
                title: const Text('Share Trip', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Share one of your trips'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share trip coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.post_add_outlined, color: AppColors.primary),
                title: const Text('Share Post', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Share a feed post'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share post coming soon!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop'),
            ),
            SizedBox(width: 10),
            Text('Marcus Chen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: _showShareOptions),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg['sender'] == 'me';

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary, fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary),
                    onPressed: _showShareOptions,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Share outfit or send message...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
