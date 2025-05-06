import 'package:weather_app/models/air_pollution_model.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final int pressure;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final int? airQualityIndex;
  final AirPollution? airPollution;
  final double latitude;
  final double longitude;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
    this.airQualityIndex,
    this.airPollution,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'],
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      windDirection: json['wind']['deg'],
      pressure: json['main']['pressure'],
      visibility: json['visibility'] ?? 0,
      latitude: json['coord']['lat'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunrise'] * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      airQualityIndex: json['air_quality_index'],
      airPollution:
          json['air_pollution'] != null
              ? AirPollution.fromJson(json['air_pollution'])
              : null,
    );
  }
}
