class WeatherForecastModel {
  final String date;
  final String minTemperature;
  final String maxTemperature;
  final String humidity;
  final String temperature;
  final String condition;
  final String weather;
  final String windSpeed;

  WeatherForecastModel({
    required this.date,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.temperature,
    required this.condition,
    required this.weather,
    required this.windSpeed,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastModel(
      date: json['dt_txt'],
      minTemperature: json['main']['temp_min'].toString(),
      maxTemperature: json['main']['temp_max'].toString(),
      temperature: json['main']['temp'].toString(),
      humidity: json['main']['humidity'].toString(),
      condition: json['weather'][0]['main'],
      weather: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toString(),
    );
  }
}
