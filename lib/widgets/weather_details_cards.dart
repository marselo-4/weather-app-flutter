import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants.dart';

class WeatherDetailsCardsWidget extends StatelessWidget {
  final Weather? weather;

  const WeatherDetailsCardsWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    if (weather == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customPrimaryColor),
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'TODAY\'S DETAILS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: customPrimaryColor,
              letterSpacing: 1.5,
            ),
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              context,
              Icons.water_drop_outlined,
              'Humidity',
              '${weather!.humidity}%',
              flex: 1,
            ),
            const SizedBox(width: 16),
            _buildDetailCard(
              context,
              Icons.air_outlined,
              'Wind',
              '${weather!.windSpeed.toStringAsFixed(1)} km/h',
              subtitle: _getWindDirection(weather!.windDirection),
              flex: 1,
            ),
          ],
        ),

        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              context,
              Icons.visibility_outlined,
              'Visibility',
              '${(weather!.visibility / 1000).toStringAsFixed(1)} km',
              flex: 1,
            ),
            const SizedBox(width: 16),
            _buildDetailCard(
              context,
              Icons.speed_outlined,
              'Pressure',
              '${weather!.pressure} hPa',
              flex: 1,
            ),
          ],
        ),

        const SizedBox(height: 25),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB74D), Color(0xFFFB8C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withAlpha(62),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSunTimeColumn(
                context,
                Icons.wb_sunny_outlined,
                'Sunrise',
                _formatTime(weather!.sunrise),
              ),
              Container(
                height: 60,
                width: 1.5,
                color: Colors.white.withAlpha(60),
              ),
              _buildSunTimeColumn(
                context,
                Icons.nightlight_round_outlined,
                'Sunset',
                _formatTime(weather!.sunset),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getAirQualityColors(weather!.airQualityIndex ?? 0),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _getAirQualityColors(
                  weather!.airQualityIndex ?? 0,
                )[0].withAlpha(62),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.air_rounded, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Air Quality Index',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${weather!.airQualityIndex ?? "N/A"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 60,
                width: 1.5,
                color: Colors.white.withAlpha(60),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.health_and_safety_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Health Impact',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAirQualityStatus(weather!.airQualityIndex ?? 0),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    String? subtitle,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(34),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: customPrimaryColor),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSunTimeColumn(
    BuildContext context,
    IconData icon,
    String label,
    String time,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    int index = ((degrees % 360) / 45).round() % 8;
    return directions[index];
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  List<Color> _getAirQualityColors(int aqi) {
    print('Current AQI value: $aqi');
    switch (aqi) {
      case 1:
        return [const Color(0xFF50F0E6), const Color(0xFF00E3FF)];
      case 2:
        return [const Color(0xFF50C878), const Color(0xFF00B050)];
      case 3:
        return [const Color(0xFFFFD700), const Color(0xFFFFA500)];
      case 4:
        return [const Color(0xFFFF6B6B), const Color(0xFFFF0000)];
      default:
        return [const Color(0xFF8B0000), const Color(0xFF800000)];
    }
  }

  String _getAirQualityStatus(int aqi) {
    print('Getting status for AQI: $aqi');
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      default:
        return 'Very Poor';
    }
  }
}
