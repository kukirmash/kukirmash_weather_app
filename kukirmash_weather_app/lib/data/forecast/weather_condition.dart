/// Погодное состояние, соответствующее коду WMO из ответа Open-Meteo.
///
/// Для каждого состояния заданы текстовое описание и картинка из assets.
enum WeatherCondition {
  clear('Ясно', 'assets/images/sun.png'),
  mainlyClear('Преимущественно ясно', 'assets/images/sun.png'),
  partlyCloudy('Переменная облачность', 'assets/images/cloud-sun.png'),
  overcast('Пасмурно', 'assets/images/cloud-sun.png'),
  fog('Туман', 'assets/images/cloud-sun.png'),
  drizzle('Морось', 'assets/images/rain.png'),
  freezingDrizzle('Ледяная морось', 'assets/images/rain.png'),
  lightRain('Небольшой дождь', 'assets/images/rain.png'),
  rain('Дождь', 'assets/images/rain.png'),
  heavyRain('Сильный дождь', 'assets/images/rain.png'),
  freezingRain('Ледяной дождь', 'assets/images/rain.png'),
  lightSnow('Небольшой снег', 'assets/images/rain.png'),
  snow('Снег', 'assets/images/rain.png'),
  heavySnow('Сильный снег', 'assets/images/rain.png'),
  snowGrains('Снежная крупа', 'assets/images/rain.png'),
  lightShowers('Небольшой ливень', 'assets/images/rain.png'),
  showers('Ливень', 'assets/images/rain.png'),
  violentShowers('Сильный ливень', 'assets/images/rain.png'),
  snowShowers('Снегопад', 'assets/images/rain.png'),
  thunderstorm('Гроза', 'assets/images/storm.png'),
  thunderstormHail('Гроза с градом', 'assets/images/storm.png');

  const WeatherCondition(this.description, this.imagePath);

  /// Текстовое описание состояния для интерфейса.
  final String description;

  /// Путь к картинке состояния внутри assets.
  final String imagePath;

  /// Сопоставляет коду WMO (поле weather_code) состояние приложения.
  static WeatherCondition fromCode(int code) {
    return switch (code) {
      0 => WeatherCondition.clear,
      1 => WeatherCondition.mainlyClear,
      2 => WeatherCondition.partlyCloudy,
      3 => WeatherCondition.overcast,
      45 || 48 => WeatherCondition.fog,
      51 || 53 || 55 => WeatherCondition.drizzle,
      56 || 57 => WeatherCondition.freezingDrizzle,
      61 => WeatherCondition.lightRain,
      63 => WeatherCondition.rain,
      65 => WeatherCondition.heavyRain,
      66 || 67 => WeatherCondition.freezingRain,
      71 => WeatherCondition.lightSnow,
      73 => WeatherCondition.snow,
      75 => WeatherCondition.heavySnow,
      77 => WeatherCondition.snowGrains,
      80 => WeatherCondition.lightShowers,
      81 => WeatherCondition.showers,
      82 => WeatherCondition.violentShowers,
      85 || 86 => WeatherCondition.snowShowers,
      95 => WeatherCondition.thunderstorm,
      96 || 99 => WeatherCondition.thunderstormHail,
      _ => WeatherCondition.partlyCloudy,
    };
  }
}
