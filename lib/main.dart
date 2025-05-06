import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/screens/weather_map_screen.dart';
import 'package:weather_app/services/city_data_cache.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CityDataCache().loadCities();

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WeatherScreen(),
        '/map':
            (context) => const WeatherMapScreen(
              apiKey: '117c225d3b7af650b6792e6fbbb07137',
            ),
      },
    );
  }
}
