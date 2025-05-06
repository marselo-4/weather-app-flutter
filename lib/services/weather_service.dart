import 'dart:convert';

import 'package:weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/air_pollution_model.dart';

class WeatherService {
  static const baseURL = "https://api.openweathermap.org/data/2.5/weather";
  static const airPollutionURL =
      "https://api.openweathermap.org/data/2.5/air_pollution";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final weatherResponse = await http.get(
      Uri.parse('$baseURL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (weatherResponse.statusCode == 200) {
      final weatherData = json.decode(weatherResponse.body);
      final lat = weatherData['coord']['lat'];
      final lon = weatherData['coord']['lon'];

      try {
        final airQualityData = await getAirQuality(lat, lon);
        weatherData['air_quality_index'] =
            airQualityData['list'][0]['main']['aqi'];
        weatherData['air_pollution'] = airQualityData['list'][0];
      } catch (e) {
        print('Error fetching air quality: $e');
      }

      return Weather.fromJson(weatherData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city = placemarks[0].locality;

    return city ?? "";
  }

  Future<List<double>> getCityCoordinates(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isEmpty) {
        throw Exception('No coordinates found for $cityName');
      }
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;

      return [latitude, longitude];
    } catch (e) {
      throw Exception('Failed to get coordinates for $cityName: $e');
    }
  }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseURL?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> weatherData = jsonDecode(response.body);

      try {
        final airQualityData = await getAirQuality(lat, lon);
        weatherData['air_quality_index'] =
            airQualityData['list'][0]['main']['aqi'];
        weatherData['air_pollution'] = airQualityData['list'][0];
      } catch (e) {
        print('Error fetching air quality: $e');
      }

      return Weather.fromJson(weatherData);
    } else {
      throw Exception('Failed to load weather data for coordinates');
    }
  }

  Future<AirPollution> getAirPollution(String cityName) async {
    try {
      List<double> coordinates = await getCityCoordinates(cityName);
      final response = await http.get(
        Uri.parse(
          '$airPollutionURL?lat=${coordinates[0]}&lon=${coordinates[1]}&appid=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        return AirPollution.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to fetch air pollution data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting air pollution: $e');
    }
  }

  Future<Map<String, dynamic>> getAirQuality(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$airPollutionURL?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to load air quality data: ${response.statusCode}',
      );
    }
  }
}
