class WeatherForecast {
  final List<WeatherData> list;
  final City city;

  WeatherForecast({required this.list, required this.city});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      list:
          (json['list'] as List)
              .map((item) => WeatherData.fromJson(item))
              .toList(),
      city: City.fromJson(json['city']),
    );
  }

  // Get daily forecasts (one forecast per day)
  List<WeatherData> getDailyForecasts() {
    final Map<String, WeatherData> dailyForecasts = {};

    for (var forecast in list) {
      final date = forecast.dtTxt.toString().split(' ')[0];
      if (!dailyForecasts.containsKey(date)) {
        dailyForecasts[date] = forecast;
      }
    }

    return dailyForecasts.values.toList();
  }
}

class WeatherData {
  final DateTime dtTxt;
  final Main main;
  final List<Weather> weather;
  final Wind wind;

  WeatherData({
    required this.dtTxt,
    required this.main,
    required this.weather,
    required this.wind,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      dtTxt: DateTime.parse(json['dt_txt']),
      main: Main.fromJson(json['main']),
      weather:
          (json['weather'] as List)
              .map((item) => Weather.fromJson(item))
              .toList(),
      wind: Wind.fromJson(json['wind']),
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      humidity: json['humidity'],
    );
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Wind {
  final double speed;
  final int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(speed: json['speed'].toDouble(), deg: json['deg']);
  }
}

class City {
  final String name;
  final String country;

  City({required this.name, required this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json['name'], country: json['country']);
  }
}
