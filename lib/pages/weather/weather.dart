import 'package:flutter/material.dart';
import 'package:palhetas/util/data/weather.dart';
import 'package:weather_pack/weather_pack.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  ///Current Weather Visual
  Widget _currentWeatherVisual({required WeatherCurrent weather}) {
    //Icon
    IconData iconData;

    //Set Icon based on Weather Condition Code
    switch (weather.weatherConditionCode) {
      case 200:
      case 201:
      case 202:
      case 230:
      case 231:
      case 232:
        iconData = Icons.storm; // Thunderstorm
        break;
      case 210:
      case 211:
      case 212:
      case 221:
        iconData = Icons.flash_on; // Thunderstorm with rain
        break;
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
        iconData = Icons.grain; // Drizzle
        break;
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 511:
      case 520:
      case 521:
      case 522:
      case 531:
        iconData = Icons.umbrella; // Rain
        break;
      case 600:
      case 601:
      case 602:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        iconData = Icons.ac_unit; // Snow
        break;
      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        iconData = Icons.cloud; // Atmosphere
        break;
      case 800:
        iconData = Icons.wb_sunny; // Clear sky
        break;
      case 801:
      case 802:
        iconData = Icons.cloud_queue; // Few clouds
        break;
      case 803:
      case 804:
        iconData = Icons.cloud; // Overcast clouds
        break;
      default:
        iconData = Icons.help_outline; // Unknown or unhandled condition
    }

    return Icon(iconData, size: 200.0);
  }

  ///Current Temperature in Celcius
  int _currentTempInCelsius({required double kelvin}) {
    return WeatherHandler.tempInCelsius(kelvin: kelvin);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WeatherHandler.current(),
      builder: (context, snapshot) {
        //Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          //Data
          final data = snapshot.data;

          //Check Data
          if (data != null) {
            //UI
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Current Weather Visual
                Center(child: _currentWeatherVisual(weather: data)),

                //Current Temperature
                Center(
                  child: Text(
                    "${_currentTempInCelsius(kelvin: data.temp!)}º (${_currentTempInCelsius(kelvin: data.tempFeelsLike!)}º)",
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Erro Interno"));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
