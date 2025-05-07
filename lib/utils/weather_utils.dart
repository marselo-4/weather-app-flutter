import 'package:flutter/material.dart';

String getWeatherAnimation(String? condition) {
  if (condition == null) return 'lib/assets/Sunny.json';

  switch (condition.toLowerCase()) {
    case 'clear':
      return 'lib/assets/Sunny.json';
    case 'clouds':
      return 'lib/assets/Cloudy.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'lib/assets/Rainy.json';
    case 'thunderstorm':
      return 'lib/assets/Thunder.json';
    case 'snow':
      return 'lib/assets/Snowy.json';
    case 'mist':
    case 'smoke':
    case 'dust':
    case 'fog':
      return 'lib/assets/Cloudy.json';
    default:
      return 'lib/assets/Sunny.json';
  }
}

Color getWeatherColor(String condition) {
  switch (condition.toLowerCase()) {
    case 'clear':
      return Colors.orange;
    case 'clouds':
      return Colors.blueGrey;
    case 'rain':
    case 'drizzle':
      return Colors.blue;
    case 'thunderstorm':
      return Colors.deepPurple;
    case 'snow':
      return Colors.lightBlue;
    case 'mist':
    case 'fog':
      return Colors.grey;
    default:
      return Colors.blue;
  }
}

String translateWeatherDescription(String description) {
  switch (description.toLowerCase()) {
    case 'cielo despejado':
      return 'Clear sky';
    case 'cielo claro':
      return 'Clear sky';
    case 'algo de nubes':
      return 'Few clouds';
    case 'algunas nubes':
      return 'Few clouds';
    case 'nubes':
      return 'Cloudy';
    case 'nubes dispersas':
      return 'Scattered clouds';
    case 'nublado':
      return 'Cloudy';
    case 'muy nublado':
      return 'Overcast';
    case 'lluvia ligera':
      return 'Light rain';
    case 'lluvia moderada':
      return 'Moderate rain';
    case 'lluvia intensa':
      return 'Heavy rain';
    case 'lluvia de gran intensidad':
      return 'Very heavy rain';
    case 'lluvia extrema':
      return 'Extreme rain';
    case 'llovizna ligera':
      return 'Light drizzle';
    case 'llovizna':
      return 'Drizzle';
    case 'llovizna intensa':
      return 'Heavy drizzle';
    case 'tormenta eléctrica':
      return 'Thunderstorm';
    case 'tormenta eléctrica con lluvia ligera':
      return 'Thunderstorm with light rain';
    case 'tormenta eléctrica con lluvia':
      return 'Thunderstorm with rain';
    case 'tormenta eléctrica con lluvia intensa':
      return 'Thunderstorm with heavy rain';
    case 'nieve ligera':
      return 'Light snow';
    case 'nieve':
      return 'Snow';
    case 'nieve intensa':
      return 'Heavy snow';
    case 'nevada':
      return 'Snowfall';
    case 'niebla':
      return 'Fog';
    case 'neblina':
      return 'Mist';
    case 'humo':
      return 'Smoke';
    case 'bruma':
      return 'Haze';
    case 'polvo':
      return 'Dust';
    case 'arena':
      return 'Sand';
    case 'ceniza volcánica':
      return 'Volcanic ash';
    case 'torbellino':
      return 'Squalls';
    case 'tornado':
      return 'Tornado';
    default:
      return description;
  }
}
