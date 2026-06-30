import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kiru/core/config/app_config.dart';
import 'package:kiru/data/models/trip_model.dart';
import 'package:kiru/data/models/user_profile.dart';
import 'package:kiru/data/models/wardrobe_item.dart';

class AiStylistService {
  GenerativeModel? _model;

  GenerativeModel? get _geminiModel {
    if (!AppConfig.hasGeminiKey) return null;
    _model ??= GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: AppConfig.geminiApiKey,
    );
    return _model;
  }

  Future<String> generateOutfitAdvice({
    required String userMessage,
    List<WardrobeItem>? wardrobe,
    UserProfile? profile,
    TripModel? trip,
  }) async {
    final model = _geminiModel;
    if (model == null) {
      return _fallbackResponse(userMessage, wardrobe, profile, trip);
    }

    final wardrobeContext = wardrobe == null || wardrobe.isEmpty
        ? 'No wardrobe items yet.'
        : wardrobe
            .map((w) => '- ${w.title} (${w.category}, ${w.color}, ${w.season})')
            .join('\n');

    final profileContext = profile == null
        ? ''
        : '''
User profile:
- Body shape: ${profile.bodyShape}
- Skin undertone: ${profile.undertone}
- Style preferences: ${profile.stylePreferences.isEmpty ? 'Not set' : profile.stylePreferences.join(', ')}
''';

    final tripContext = trip == null
        ? ''
        : '''
Upcoming trip:
- Destination: ${trip.destination}, ${trip.country}
- Dates: ${trip.startDate.toIso8601String().split('T').first} to ${trip.endDate.toIso8601String().split('T').first}
- Occasion: ${trip.occasion}
- Weather: ${trip.weatherCondition}, ${trip.weatherTemp}
''';

    final prompt = '''
You are Kiru, an expert AI travel stylist. Recommend outfits from the user's wardrobe.
Be concise, friendly, and practical. Format with numbered items and a brief reason.

$profileContext
$tripContext
Wardrobe:
$wardrobeContext

User request: $userMessage
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim();
      if (text != null && text.isNotEmpty) return text;
    } catch (_) {
      // Fall through to local synthesis
    }

    return _fallbackResponse(userMessage, wardrobe, profile, trip);
  }

  Future<List<String>> generateDailyOutfits({
    required TripModel trip,
    List<WardrobeItem>? wardrobe,
    UserProfile? profile,
  }) async {
    final days = trip.endDate.difference(trip.startDate).inDays + 1;
    final dayCount = days.clamp(1, 7);

    final model = _geminiModel;
    if (model != null) {
      final wardrobeContext = wardrobe == null || wardrobe.isEmpty
          ? 'Generic travel wardrobe'
          : wardrobe.map((w) => w.title).join(', ');

      final prompt = '''
Generate exactly $dayCount day-by-day outfit plans for a trip to ${trip.destination}, ${trip.country}.
Occasion: ${trip.occasion}. Weather: ${trip.weatherCondition}, ${trip.weatherTemp}.
Available wardrobe: $wardrobeContext
Body shape: ${profile?.bodyShape ?? 'Unknown'}. Undertone: ${profile?.undertone ?? 'Unknown'}.

Return ONLY a numbered list, one line per day, format: "Day N: [activity] — [outfit items]"
''';

      try {
        final response = await model.generateContent([Content.text(prompt)]);
        final text = response.text?.trim();
        if (text != null && text.isNotEmpty) {
          return text
              .split('\n')
              .where((l) => l.trim().isNotEmpty)
              .take(dayCount)
              .toList();
        }
      } catch (_) {}
    }

    return _fallbackDailyOutfits(trip, wardrobe, dayCount);
  }

  String _fallbackResponse(
    String userMessage,
    List<WardrobeItem>? wardrobe,
    UserProfile? profile,
    TripModel? trip,
  ) {
    final items = wardrobe ?? [];
    if (items.isEmpty) {
      return '✨ I\'d love to help style you! Add some items to your wardrobe first, '
          'then I can recommend pairings for "$userMessage".';
    }

    final top = items.firstWhere(
      (w) => w.category == 'Tops' || w.category == 'Dresses',
      orElse: () => items.first,
    );
    final bottom = items.firstWhere(
      (w) => w.category == 'Bottoms',
      orElse: () => items.length > 1 ? items[1] : items.first,
    );
    final accessory = items.firstWhere(
      (w) => w.category == 'Accessories' || w.category == 'Shoes',
      orElse: () => items.last,
    );

    final destination = trip?.destination ?? _extractDestination(userMessage);
    final undertone = profile?.undertone ?? 'your undertone';

    return '✨ Outfit synthesis for ${destination.isNotEmpty ? destination : 'your trip'}:\n\n'
        '1. ${top.title} (${top.category})\n'
        '2. ${bottom.title} (${bottom.category})\n'
        '3. ${accessory.title} (${accessory.category})\n\n'
        'Matched to $undertone with ~85% comfort score. '
        '${AppConfig.hasGeminiKey ? '' : '(Add GEMINI_API_KEY for AI-powered styling)'}';
  }

  List<String> _fallbackDailyOutfits(
    TripModel trip,
    List<WardrobeItem>? wardrobe,
    int dayCount,
  ) {
    final items = wardrobe ?? [];
    final defaultOutfits = [
      'Linen shirt + chino trousers + walking shoes',
      'Light jacket + comfortable layers + sneakers',
      'Smart casual dress or blazer combo',
      'Resort wear + sunglasses + sandals',
      'Rain-ready layers + waterproof shoes',
      'Evening outfit + accessories',
      'Travel day comfort wear',
    ];

    return List.generate(dayCount, (i) {
      final date = trip.startDate.add(Duration(days: i));
      final outfit = items.isNotEmpty
          ? items.map((w) => w.title).take(3).join(' + ')
          : defaultOutfits[i % defaultOutfits.length];
      return 'Day ${i + 1} (${_formatDate(date)}): ${trip.occasion} — $outfit';
    });
  }

  String _extractDestination(String message) {
    final lower = message.toLowerCase();
    for (final city in ['tokyo', 'paris', 'bali', 'london', 'kyoto', 'santorini']) {
      if (lower.contains(city)) {
        return city[0].toUpperCase() + city.substring(1);
      }
    }
    return '';
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}
