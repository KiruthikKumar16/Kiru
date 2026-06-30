import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/config/app_config.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/providers/service_providers.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';

class AiStylistScreen extends ConsumerStatefulWidget {
  const AiStylistScreen({super.key});

  @override
  ConsumerState<AiStylistScreen> createState() => _AiStylistScreenState();
}

class _AiStylistScreenState extends ConsumerState<AiStylistScreen> {
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text':
          'Hello! I am your AI Travel Stylist. Tell me where you are traveling or tap a prompt below to get outfit ideas from your wardrobe!',
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    final wardrobe = ref.read(wardrobeItemsProvider);
    final profile = ref.read(userProfileProvider);
    final trips = ref.read(tripsProvider);
    final upcomingTrip = trips.isNotEmpty ? trips.first : null;

    final response = await ref.read(aiStylistServiceProvider).generateOutfitAdvice(
          userMessage: text,
          wardrobe: wardrobe,
          profile: profile,
          trip: upcomingTrip,
        );

    if (mounted) {
      setState(() {
        _messages.add({'sender': 'ai', 'text': response});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              AppConfig.hasGeminiKey ? 'Gemini AI Stylist' : 'AI Stylist',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: isAi ? AppColors.surface : AppColors.primary,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: isAi ? Border.all(color: AppColors.border) : null,
                        ),
                        child: Text(
                          msg['text']!,
                          style: TextStyle(
                            color: isAi ? AppColors.textPrimary : Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isLoading,
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
                    icon: Icon(Icons.send, color: _isLoading ? AppColors.textSecondary : AppColors.primary),
                    onPressed: _isLoading ? null : () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        backgroundColor: AppColors.surface,
        onPressed: _isLoading ? null : () => _sendMessage('Style me for $text'),
      ),
    );
  }
}
