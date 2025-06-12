import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweatherstates.dart';
import 'package:weatherapp/Models/WeatherModel.dart';
import 'package:weatherapp/service/ApiWeather.dart';

class GetweatherCubit extends Cubit<WeatherState> {
  GetweatherCubit() : super(NoWeatherState());

  // 🔑 IMPORTANT: Replace this API key with your own from weatherapi.com
  // 1. Visit https://www.weatherapi.com/
  // 2. Sign up for free
  // 3. Get your API key from the dashboard
  // 4. Replace the key below with your own
  static const String YOUR_API_KEY = 'bb7ea3681d7f4024a6c190317242010'; // ✅ Updated with your API key!

  Weather_Model? weatherModel;

  getWeather({required String cityName}) async {
    try {
      emit(WeatherLoadingState());
      
      // Check if user has set their own API key
      if (YOUR_API_KEY == 'YOUR_API_KEY_HERE') {
        emit(FailerState(
          errorMessage: 'API key is invalid. Please get a new API key from weatherapi.com and replace YOUR_API_KEY_HERE in the code.'
        ));
        return;
      }
      
      weatherApi weatherApiObject = weatherApi(
        BaseUrl: 'https://api.weatherapi.com/v1',
        Api_Key: YOUR_API_KEY,
        dio: Dio(),
      );
      
      weatherModel = await weatherApiObject.Get_Current_Weather(
        CityName: cityName,
      );
      
      emit(WeatherLoadedState(model: weatherModel!));
    } catch (e) {
      print('GetweatherCubit Error: ${e.toString()}');
      emit(FailerState(errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }
}