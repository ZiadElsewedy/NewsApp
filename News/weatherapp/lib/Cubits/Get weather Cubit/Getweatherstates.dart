import 'package:weatherapp/Models/WeatherModel.dart';

class WeatherState{}
class NoWeatherState extends WeatherState{}
class WeatherLoadingState extends WeatherState{}
class WeatherLoadedState extends WeatherState{
    final Weather_Model model;

  WeatherLoadedState({required this.model});
}
class FailerState extends WeatherState{
  final String? errorMessage;
  
  FailerState({this.errorMessage});
}


