enum AirQualityLevel { good, fair, moderate, poor, veryPoor }

class AirPollution {
  final double? so2;
  final double? no2;
  final double? pm10;
  final double? pm25;
  final double? o3;
  final double? co;

  AirPollution({this.so2, this.no2, this.pm10, this.pm25, this.o3, this.co});

  factory AirPollution.fromJson(Map<String, dynamic> json) {
    return AirPollution(
      so2: json['components']['so2']?.toDouble(),
      no2: json['components']['no2']?.toDouble(),
      pm10: json['components']['pm10']?.toDouble(),
      pm25: json['components']['pm2_5']?.toDouble(),
      o3: json['components']['o3']?.toDouble(),
      co: json['components']['co']?.toDouble(),
    );
  }

  AirQualityLevel calculateAQI() {
    List<AirQualityLevel> levels = [];

    if (so2 != null) {
      if (so2! < 20)
        levels.add(AirQualityLevel.good);
      else if (so2! < 80)
        levels.add(AirQualityLevel.fair);
      else if (so2! < 250)
        levels.add(AirQualityLevel.moderate);
      else if (so2! < 350)
        levels.add(AirQualityLevel.poor);
      else
        levels.add(AirQualityLevel.veryPoor);
    }

    // Similar checks for other pollutants
    if (no2 != null) {
      if (no2! < 40)
        levels.add(AirQualityLevel.good);
      else if (no2! < 70)
        levels.add(AirQualityLevel.fair);
      else if (no2! < 150)
        levels.add(AirQualityLevel.moderate);
      else if (no2! < 200)
        levels.add(AirQualityLevel.poor);
      else
        levels.add(AirQualityLevel.veryPoor);
    }

    // Return the worst air quality level found
    if (levels.isEmpty) return AirQualityLevel.good;
    return levels.reduce((curr, next) => curr.index > next.index ? curr : next);
  }

  int getAQIValue() {
    return calculateAQI().index + 1;
  }
}
