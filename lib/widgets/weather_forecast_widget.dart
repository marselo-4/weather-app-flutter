import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import '../models/weather_forecast.dart';
import '../services/weather_forecast_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../utils/weather_utils.dart';

class WeatherForecastWidget extends StatefulWidget {
  final String city;

  const WeatherForecastWidget({Key? key, required this.city}) : super(key: key);

  @override
  State<WeatherForecastWidget> createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  late Future<WeatherForecast> _forecastFuture;
  bool _isDailyView = true;
  bool _isDateFormatInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('es_ES', null);
    if (mounted) {
      setState(() {
        _isDateFormatInitialized = true;
      });
    }
    _loadForecast();
  }

  @override
  void didUpdateWidget(WeatherForecastWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.city != widget.city) {
      _loadForecast();
    }
  }

  void _loadForecast() {
    _forecastFuture =
        WeatherForecastService(widget.city).fetchWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDateFormatInitialized) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FORECAST',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: customPrimaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isDailyView ? Icons.calendar_month : Icons.view_day,
                      color: customPrimaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isDailyView = !_isDailyView;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: FutureBuilder<WeatherForecast>(
                future: _forecastFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('No data available'));
                  }

                  final forecast = snapshot.data!;
                  final forecasts =
                      _isDailyView
                          ? forecast.getDailyForecasts()
                          : forecast.list;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: forecasts.length,
                    itemBuilder: (context, index) {
                      final weatherData = forecasts[index];
                      final weatherColor = getWeatherColor(
                        weatherData.weather.first.main,
                      );

                      return Container(
                        width: 140,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: weatherColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: weatherColor.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat(
                                  'EEEE',
                                  'en_US',
                                ).format(weatherData.dtTxt),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: weatherColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                _isDailyView
                                    ? DateFormat(
                                      'd MMM',
                                      'en_US',
                                    ).format(weatherData.dtTxt)
                                    : DateFormat(
                                      'HH:mm',
                                      'en_US',
                                    ).format(weatherData.dtTxt),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: weatherColor.withOpacity(0.7),
                                ),
                              ),
                              Image.network(
                                'https://openweathermap.org/img/wn/${weatherData.weather.first.icon}@2x.png',
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.cloud, size: 50);
                                },
                              ),
                              Text(
                                '${weatherData.main.temp.toStringAsFixed(1)}°C',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: weatherColor,
                                ),
                              ),
                              Text(
                                translateWeatherDescription(
                                  weatherData.weather.first.description,
                                ),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: weatherColor.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
