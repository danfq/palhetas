import 'package:get/get.dart';
import 'package:palhetas/util/data/constants.dart';
import 'package:weather_pack/weather_pack.dart';

///Weather Handler
class WeatherHandler {
  ///Weather Service Instance
  static final WeatherService _weatherService = WeatherService(
    Constants.weatherServiceAPIKey,
    oneCallApi: OneCallApi.api_3_0,
    language: WeatherLanguage.portuguese,
  );

  ///Current Weather
  static Future<WeatherCurrent> current() async {
    return await _weatherService.currentWeatherByLocation(
      latitude: 40.1557961,
      longitude: -8.8780343,
    );
  }

  ///Temperature in Celsius
  static int tempInCelsius({required double kelvin}) {
    //Temperature
    final celsius = kelvin - 273.15;

    //Return Temperature
    return int.parse(celsius.toPrecision(0).toString().split(".").first);
  }
}
