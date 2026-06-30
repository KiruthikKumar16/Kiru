/// Runtime configuration loaded via `--dart-define`.
///
/// Example run:
/// flutter run --dart-define=GEMINI_API_KEY=your_key --dart-define=OPENWEATHERMAP_API_KEY=your_key
class AppConfig {
  static const geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHERMAP_API_KEY',
    defaultValue: '',
  );

  static bool get hasGeminiKey =>
      geminiApiKey.isNotEmpty && geminiApiKey != 'YOUR_GEMINI_API_KEY';

  static bool get hasWeatherKey =>
      openWeatherApiKey.isNotEmpty &&
      openWeatherApiKey != 'YOUR_OPENWEATHERMAP_API_KEY';
}
