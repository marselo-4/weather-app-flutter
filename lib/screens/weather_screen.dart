import 'package:weather_app/constants.dart';
import 'package:weather_app/widgets/city_search_dialog.dart';
import 'package:weather_app/widgets/country_city_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_display.dart';
import 'package:weather_app/widgets/search_options_sheet.dart';
import 'package:weather_app/utils/weather_utils.dart';
import 'package:weather_app/widgets/custom_drawer.dart';
import 'package:weather_app/widgets/weather_forecast_widget.dart';

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

  Future<void> _fetchWeatherByCoordinates(double lat, double lon) async {
    if (!mounted) return;

    try {
      final weather = await _weatherService.getWeatherByCoordinates(lat, lon);

      if (!mounted) return;
      setState(() {
        _weather = weather;
        _currentSearchType =
            '${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)}';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch weather: $e')));
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
            onCoordinateSearchSelected: _showCoordinateSearchDialog, // Add this
          ),
    );
  }

  void _showCoordinateSearchDialog() {
    TextEditingController latController = TextEditingController();
    TextEditingController lonController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search by Coordinates'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: latController,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    hintText: 'Enter latitude (-90 to 90)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: lonController,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    hintText: 'Enter longitude (-180 to 180)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  double? lat = double.tryParse(latController.text);
                  double? lon = double.tryParse(lonController.text);

                  if (lat != null &&
                      lon != null &&
                      lat >= -90 &&
                      lat <= 90 &&
                      lon >= -180 &&
                      lon <= 180) {
                    Navigator.pop(context);
                    _fetchWeatherByCoordinates(lat, lon);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid coordinates')),
                    );
                  }
                },
                child: const Text('Search'),
              ),
            ],
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
      drawer: const CustomDrawer(),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            WeatherDisplay(
              weather: _weather,
              animationPath: getWeatherAnimation(_weather?.condition),
            ),
            if (_weather != null)
              WeatherForecastWidget(
                city:
                    _currentSearchType == 'Current Location'
                        ? _weather!.cityName
                        : _currentSearchType,
              ),
          ],
        ),
      ),
    );
  }
}
