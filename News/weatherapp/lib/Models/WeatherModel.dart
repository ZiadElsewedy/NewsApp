class Weather_Model {
final String CityName;
final String Date;
final String? Image;
final double Temp;
final double Max_Temp;
final double Min_Temp;
final String WeatherCondition;

  Weather_Model({
required this.CityName,
required this.Date,
this.Image,
required this.Temp,
required this.Max_Temp,
required this.Min_Temp,
required this.WeatherCondition});

  factory Weather_Model.fromJson(Map<String, dynamic> json){
    try {
      print('Parsing JSON: $json');
      
      // Safely extract data with null checks
      final location = json["location"] as Map<String, dynamic>?;
      final current = json["current"] as Map<String, dynamic>?;
      final forecast = json["forecast"] as Map<String, dynamic>?;
      final forecastDay = forecast?["forecastday"] as List?;
      final dayData = forecastDay?.isNotEmpty == true ? forecastDay![0]["day"] as Map<String, dynamic>? : null;
      final condition = dayData?["condition"] as Map<String, dynamic>?;
      
      return Weather_Model(
        Image: condition?["icon"]?.toString(),
        CityName: location?["name"]?.toString() ?? "Unknown Location",
        Date: current?["last_updated"]?.toString() ?? DateTime.now().toString(),
        Temp: _parseDouble(dayData?["avgtemp_c"]) ?? _parseDouble(current?["temp_c"]) ?? 0.0,
        Max_Temp: _parseDouble(dayData?["maxtemp_c"]) ?? _parseDouble(current?["temp_c"]) ?? 0.0,
        Min_Temp: _parseDouble(dayData?["mintemp_c"]) ?? _parseDouble(current?["temp_c"]) ?? 0.0,
        WeatherCondition: condition?["text"]?.toString() ?? current?["condition"]?["text"]?.toString() ?? "Unknown",
      );
    } catch (e) {
      print('Error parsing weather data: $e');
      throw Exception('Failed to parse weather data: $e');
    }
  }
  
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}