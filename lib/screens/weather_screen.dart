// weather screen main logic file

import 'package:weather_app/widgets/city_search_dialog.dart';
import 'package:weather_app/widgets/country_city_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_display.dart';
import 'package:weather_app/widgets/search_options_sheet.dart';
import 'package:weather_app/utils/weather_utils.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = WeatherService('ed0016d9786e04cd0b5344c45d3e32cf');
  Weather? _weather;
  String _currentSearchType = 'Current Location';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather([String? cityName]) async {
    if (!mounted) return;

    try {
      String city = cityName ?? await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(city);

      if (!mounted) return;
      setState(() {
        _weather = weather;

        if (cityName != null) {
          _currentSearchType = city;
        } else {
          _currentSearchType = 'Current Location';
        }
      });
    } catch (e) {
      debugPrint('$e');
      if (!mounted) return;
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to fetch weather: $e')));
      }
    }
  }

  void _showSearchOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SearchOptionsSheet(
            onCurrentLocationSelected: () => _fetchWeather(),
            onCountryCitySelected: _showCountryCityPicker,
            onCitySearchSelected: _showTypeAheadSearchDialog,
          ),
    );
  }

  void _showCountryCityPicker() {
    showDialog(
      context: context,
      builder:
          (context) => CountryCityPickerDialog(
            onCitySelected: (city) {
              if (city.isNotEmpty) {
                _fetchWeather(city);
              }
            },
          ),
    );
  }

  void _showTypeAheadSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CitySearchDialog(
            onCitySelected: (city) {
              _fetchWeather(city);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchOptions,
            tooltip: 'Search options',
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      body: Column(
        children: [
          // Location indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_pin, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _currentSearchType,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Main content area - Weather display component
          Expanded(
            child: WeatherDisplay(
              weather: _weather,
              animationPath: getWeatherAnimation(_weather?.condition),
            ),
          ),
        ],
      ),
    );
  }
}
