import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/config/app_config.dart';
import 'package:kiru/data/datasources/ai_stylist_service.dart';
import 'package:kiru/data/datasources/firebase_storage_service.dart';
import 'package:kiru/data/datasources/firestore_trip_datasource.dart';
import 'package:kiru/data/datasources/weather_api.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(apiKey: AppConfig.openWeatherApiKey);
});

final aiStylistServiceProvider = Provider<AiStylistService>((ref) {
  return AiStylistService();
});

final firestoreTripDataSourceProvider = Provider<FirestoreTripDataSource>((ref) {
  return FirestoreTripDataSource();
});

final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});
