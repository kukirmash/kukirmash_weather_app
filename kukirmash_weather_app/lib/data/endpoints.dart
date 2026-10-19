/// Конечные точки (endpoints) используемого API.
///
/// Полный адрес запроса складывается из baseUrl (задаётся в set_up.dart)
/// и одной из констант этого класса.
class Endpoints {
  Endpoints._();

  /// Прогноз погоды Open-Meteo.
  static const String forecast = '/forecast';
}
