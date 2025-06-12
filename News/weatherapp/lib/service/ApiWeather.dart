import 'package:dio/dio.dart';
import 'package:weatherapp/Models/WeatherModel.dart';

class weatherApi {
final Dio dio;
 String BaseUrl ='https://api.weatherapi.com/v1';
 String Api_Key; // Will be provided by user
weatherApi({required this.BaseUrl ,required this.Api_Key , required this.dio});

Future<Weather_Model> Get_Current_Weather({required String CityName}) async {
try {
  print('Fetching weather for: $CityName');
  print('Using API Key: ${Api_Key.substring(0, 8)}...');
  
  Response response = await dio.get(
    '$BaseUrl/forecast.json?key=$Api_Key&q=$CityName&days=1',
  );
  
  print('Response status: ${response.statusCode}');
  
  if (response.statusCode == 200 && response.data != null) {
    Weather_Model modelObject = Weather_Model.fromJson(response.data);
    return modelObject;
  } else {
    throw Exception('Invalid response from weather API');
  }
} on DioException catch (e) {
  print('DioException: ${e.toString()}');
  print('Error response: ${e.response?.data}');
  
  String errorMessage = 'Network error occurred';
  
  if (e.response?.data != null && e.response!.data['error'] != null) {
    String apiError = e.response!.data['error']['message'] ?? 'API Error';
    
    // Handle specific API errors
    if (apiError.toLowerCase().contains('invalid') || 
        apiError.toLowerCase().contains('key')) {
      errorMessage = 'API key is invalid. Please get a new API key from weatherapi.com';
    } else if (apiError.toLowerCase().contains('not found') || 
               apiError.toLowerCase().contains('no matching location')) {
      errorMessage = 'City not found. Please check the spelling and try again.';
    } else {
      errorMessage = apiError;
    }
  } else if (e.type == DioExceptionType.connectionTimeout) {
    errorMessage = 'Connection timeout - please check your internet';
  } else if (e.type == DioExceptionType.receiveTimeout) {
    errorMessage = 'Request timeout - please try again';
  } else if (e.type == DioExceptionType.connectionError) {
    errorMessage = 'No internet connection';
  }
  
  throw Exception(errorMessage);
} catch (e) {
  print('General Exception: ${e.toString()}');
  throw Exception('Failed to fetch weather data: Please check your API key');
}

 }
 
}