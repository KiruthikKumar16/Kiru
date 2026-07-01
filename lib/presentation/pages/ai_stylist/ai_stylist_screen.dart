import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';

class AiStylistScreen extends ConsumerStatefulWidget {
  const AiStylistScreen({super.key});

  @override
  ConsumerState<AiStylistScreen> createState() => _AiStylistScreenState();
}

class _AiStylistScreenState extends ConsumerState<AiStylistScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your AI Travel Stylist powered by Gemini. Tell me where you are traveling or select a prompt below to style from your wardrobe!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'timestamp': DateTime.now(),
      });
      _controller.clear();
      _isTyping = true;
    });

    // Simulate AI styling response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'sender': 'ai',
            'text': '✨ Here is your custom outfit synthesis from your Wardrobe:',
            'outfitItems': [
              {'title': 'Linen Vacation Shirt', 'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400', 'type': 'Top'},
              {'title': 'Chino Trousers', 'image': 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400', 'type': 'Bottom'},
              {'title': 'Polarized Sunglasses', 'image': 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400', 'type': 'Accessory'},
            ],
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Gemini AI Stylist', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Style Personas Chips
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildPersonaChip('Minimalist'),
                  _buildPersonaChip('Streetwear'),
                  _buildPersonaChip('Ethnic Chic'),
                  _buildPersonaChip('Preppy'),
                  _buildPersonaChip('Bohemian'),
                ],
              ),
            ),
            // Prompt recommendation pills
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildPromptChip('🌴 Beach Sunset in Bali'),
                  _buildPromptChip('🏛️ Museum Walking in Kyoto'),
                  _buildPromptChip('👔 Business Dinner in London'),
                ],
              ),
            ),
            const Divider(height: 1),

            // Messages view
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Gemini is thinking...'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  final msg = _messages[index];
                  final isAi = msg['sender'] == 'ai';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Align(
                      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: isAi ? AppColors.surface : AppColors.primary,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              border: isAi ? Border.all(color: AppColors.border) : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['text']!,
                                  style: TextStyle(
                                    color: isAi ? AppColors.textPrimary : Colors.white,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                if (msg['outfitItems'] != null) ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: msg['outfitItems'].length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                                      itemBuilder: (_, i) {
                                        final item = msg['outfitItems'][i];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                item['image'],
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                item['title'],
                                                style: const TextStyle(fontSize: 11),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.refresh, size: 20),
                                        tooltip: 'Regenerate',
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.save_outlined, size: 20),
                                        tooltip: 'Save Outfit',
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Outfit saved!')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.inventory_2_outlined, size: 20),
                                        tooltip: 'Add to Packing List',
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Added to packing list!')),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              _formatTimestamp(msg['timestamp']),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic_none_outlined),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Voice input coming soon!')),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask AI Stylist e.g. "What to wear in Tokyo?"',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonaChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        backgroundColor: AppColors.surface,
        onSelected: (val) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        backgroundColor: AppColors.surface,
        onPressed: () => _sendMessage('Style me for $text'),
      ),
    );
  }
}
