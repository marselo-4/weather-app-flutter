import 'package:http/http.dart' as http;
import 'dart:convert';

class AirQualityService {
  final String apiKey = '117c225d3b7af650b6792e6fbbb07137';
  final String baseUrl = 'http://api.openweathermap.org/data/2.5/air_pollution';

  Future<Map<String, dynamic>> getAirQualityByCoordinates(
    double lat,
    double lon,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load air quality data');
    }
  }
}
