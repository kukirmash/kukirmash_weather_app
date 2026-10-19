/// Погодное состояние, соответствующее коду WMO из ответа Open-Meteo.
///
/// Для каждого состояния заданы текстовое описание и картинка из assets.
enum WeatherCondition {
  clear('Ясно', 'Ясно', 'assets/images/sun.png'),
  mainlyClear('Преимущественно ясно', 'Почти ясно', 'assets/images/sun.png'),
  partlyCloudy(
    'Переменная облачность',
    'Облачно',
    'assets/images/cloud-sun.png',
  ),
  overcast('Пасмурно', 'Пасмурно', 'assets/images/cloud-sun.png'),
  fog('Туман', 'Туман', 'assets/images/cloud-sun.png'),
  drizzle('Морось', 'Морось', 'assets/images/rain.png'),
  freezingDrizzle('Ледяная морось', 'Морось', 'assets/images/rain.png'),
  lightRain('Небольшой дождь', 'Дождь', 'assets/images/rain.png'),
  rain('Дождь', 'Дождь', 'assets/images/rain.png'),
  heavyRain('Сильный дождь', 'Дождь', 'assets/images/rain.png'),
  freezingRain('Ледяной дождь', 'Дождь', 'assets/images/rain.png'),
  lightSnow('Небольшой снег', 'Снег', 'assets/images/rain.png'),
  snow('Снег', 'Снег', 'assets/images/rain.png'),
  heavySnow('Сильный снег', 'Снег', 'assets/images/rain.png'),
  snowGrains('Снежная крупа', 'Снег', 'assets/images/rain.png'),
  lightShowers('Небольшой ливень', 'Ливень', 'assets/images/rain.png'),
  showers('Ливень', 'Ливень', 'assets/images/rain.png'),
  violentShowers('Сильный ливень', 'Ливень', 'assets/images/rain.png'),
  snowShowers('Снегопад', 'Снегопад', 'assets/images/rain.png'),
  thunderstorm('Гроза', 'Гроза', 'assets/images/storm.png'),
  thunderstormHail('Гроза с градом', 'Гроза', 'assets/images/storm.png');

  const WeatherCondition(
    this.description,
    this.shortDescription,
    this.imagePath,
  );

  /// Текстовое описание состояния для интерфейса.
  final String description;

  /// Короткое описание для компактных карточек списка.
  final String shortDescription;

  /// Путь к картинке состояния внутри assets.
  final String imagePath;

  /// Признак осадков — используется в рекомендациях на экране деталей.
  bool get hasPrecipitation => switch (this) {
    WeatherCondition.drizzle ||
    WeatherCondition.freezingDrizzle ||
    WeatherCondition.lightRain ||
    WeatherCondition.rain ||
    WeatherCondition.heavyRain ||
    WeatherCondition.freezingRain ||
    WeatherCondition.lightSnow ||
    WeatherCondition.snow ||
    WeatherCondition.heavySnow ||
    WeatherCondition.snowGrains ||
    WeatherCondition.lightShowers ||
    WeatherCondition.showers ||
    WeatherCondition.violentShowers ||
    WeatherCondition.snowShowers ||
    WeatherCondition.thunderstorm ||
    WeatherCondition.thunderstormHail => true,
    _ => false,
  };

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
