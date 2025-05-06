import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

enum WeatherLayer { precipitation, temperature, wind }

class WeatherMapScreen extends StatefulWidget {
  final String apiKey;

  const WeatherMapScreen({super.key, required this.apiKey});

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  WeatherLayer _currentLayer = WeatherLayer.precipitation;

  String _getWeatherUrl() {
    switch (_currentLayer) {
      case WeatherLayer.precipitation:
        return 'precipitation_new';
      case WeatherLayer.temperature:
        return 'temp_new';
      case WeatherLayer.wind:
        return 'wind_new';
      default:
        return 'precipitation_new';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Map'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(40.0, -3.0),
              initialZoom: 5,
              maxZoom: 18,
              minZoom: 3,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.weatherapp',
              ),

              TileLayer(
                urlTemplate:
                    'https://tile.openweathermap.org/map/${_getWeatherUrl()}/{z}/{x}/{y}.png?appid=117c225d3b7af650b6792e6fbbb07137',
                tileProvider: NetworkTileProvider(),
              ),
            ],
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLayerButton(
                      WeatherLayer.precipitation,
                      Icons.water_drop,
                      'Rain',
                    ),
                    _buildLayerButton(
                      WeatherLayer.temperature,
                      Icons.thermostat,
                      'Temp',
                    ),
                    _buildLayerButton(WeatherLayer.wind, Icons.air, 'Wind'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerButton(WeatherLayer layer, IconData icon, String label) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        color: _currentLayer == layer ? Colors.white : Colors.blue,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentLayer == layer ? Colors.blue : Colors.white,
        foregroundColor: _currentLayer == layer ? Colors.white : Colors.blue,
      ),
      onPressed: () => setState(() => _currentLayer = layer),
    );
  }
}
