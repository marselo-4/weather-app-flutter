import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_forecast.dart';

class WeatherForecastService {
  final String apiKey = '117c225d3b7af650b6792e6fbbb07137';
  final String city;
  final String baseURL = 'https://api.openweathermap.org/data/2.5/forecast';

  WeatherForecastService(this.city);

  Future<WeatherForecast> fetchWeatherForecast() async {
    final response = await http.get(
      Uri.parse('$baseURL?q=$city&appid=$apiKey&units=metric&lang=es'),
    );

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }

  // Method to process weather forecast data
  void processWeatherForecast() {
    // Placeholder for processing weather forecast data
  }
}
