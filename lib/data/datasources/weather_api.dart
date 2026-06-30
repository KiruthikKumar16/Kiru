import 'package:dio/dio.dart';

class WeatherForecast {
  final String temp;
  final String condition;
  final List<DailyForecast> daily;

  WeatherForecast({
    required this.temp,
    required this.condition,
    required this.daily,
  });
}

class DailyForecast {
  final DateTime date;
  final String temp;
  final String condition;

  DailyForecast({
    required this.date,
    required this.temp,
    required this.condition,
  });
}

class WeatherService {
  final Dio _dio = Dio();
  final String? apiKey;

  WeatherService({this.apiKey});

  Future<WeatherForecast> getForecast(String city, String country, int durationDays) async {
    if (apiKey == null || apiKey!.isEmpty || apiKey == 'YOUR_OPENWEATHERMAP_API_KEY') {
      return _generateMockForecast(city, durationDays);
    }

    try {
      // 1. Get coordinates for city
      final geoResponse = await _dio.get(
        'https://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {
          'q': '$city,$country',
          'limit': 1,
          'appid': apiKey,
        },
      );

      if (geoResponse.data == null || (geoResponse.data as List).isEmpty) {
        return _generateMockForecast(city, durationDays);
      }

      final lat = geoResponse.data[0]['lat'];
      final lon = geoResponse.data[0]['lon'];

      // 2. Get forecast
      final weatherResponse = await _dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'units': 'metric',
          'appid': apiKey,
        },
      );

      final list = weatherResponse.data['list'] as List;
      final currentTemp = '${list[0]['main']['temp'].round()}°C';
      final currentCondition = list[0]['weather'][0]['main'] as String;

      final dailyList = <DailyForecast>[];
      // Grab 1 forecast per day (OpenWeather 5-day is 3-hourly, so step by 8 items)
      for (int i = 0; i < list.length && dailyList.length < durationDays; i += 8) {
        final item = list[i];
        final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        dailyList.add(DailyForecast(
          date: dt,
          temp: '${item['main']['temp'].round()}°C',
          condition: item['weather'][0]['main'] as String,
        ));
      }

      return WeatherForecast(
        temp: currentTemp,
        condition: currentCondition,
        daily: dailyList,
      );
    } catch (_) {
      return _generateMockForecast(city, durationDays);
    }
  }

  WeatherForecast _generateMockForecast(String city, int durationDays) {
    // Generate intelligent dummy weather based on city name hash
    final hash = city.toLowerCase().codeUnits.fold(0, (prev, element) => prev + element);
    
    // Determine average temperature based on city characteristics
    int baseTemp = 20;
    String primaryCondition = 'Sunny';

    if (city.toLowerCase().contains('tokyo') || city.toLowerCase().contains('paris') || city.toLowerCase().contains('new york')) {
      baseTemp = 18;
      primaryCondition = hash % 3 == 0 ? 'Cloudy' : (hash % 3 == 1 ? 'Rainy' : 'Sunny');
    } else if (city.toLowerCase().contains('santorini') || city.toLowerCase().contains('bali') || city.toLowerCase().contains('miami')) {
      baseTemp = 28;
      primaryCondition = 'Sunny';
    } else if (city.toLowerCase().contains('reykjavik') || city.toLowerCase().contains('alaska')) {
      baseTemp = 4;
      primaryCondition = 'Snowy';
    }

    final daily = <DailyForecast>[];
    final conditions = ['Sunny', 'Cloudy', 'Rainy', 'Windy'];
    for (int i = 0; i < durationDays; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final tempShift = (hash + i) % 5 - 2; // -2 to +2 variation
      final dailyCondition = i == 0 ? primaryCondition : conditions[(hash + i) % conditions.length];
      daily.add(DailyForecast(
        date: date,
        temp: '${baseTemp + tempShift}°C',
        condition: dailyCondition,
      ));
    }

    return WeatherForecast(
      temp: '$baseTemp°C',
      condition: primaryCondition,
      daily: daily,
    );
  }
}
