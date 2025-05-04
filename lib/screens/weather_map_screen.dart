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
              center: LatLng(40.0, -3.0),
              zoom: 5,
              maxZoom: 18,
              minZoom: 3,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                backgroundColor: Colors.transparent,
                tileBuilder: (context, widget, tile) {
                  return Opacity(opacity: 0.7, child: widget);
                },
              ),
              TileLayer(
                urlTemplate:
                    'https://tile.openweathermap.org/map/${_getWeatherUrl()}/{z}/{x}/{y}.png?appid=${widget.apiKey}',
                tileProvider: NetworkTileProvider(),
                backgroundColor: Colors.transparent,
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
                  color: Colors.white.withOpacity(0.0),
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
