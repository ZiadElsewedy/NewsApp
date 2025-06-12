import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweathercubit.dart';
import 'package:weatherapp/screens/homePage.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetweatherCubit(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Weather Forecast',
            theme: _buildTheme(context),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final cubit = BlocProvider.of<GetweatherCubit>(context);
    final weatherCondition = cubit.weatherModel?.WeatherCondition;
    
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      primarySwatch: GetThemeColor(weatherCondition),
      colorScheme: ColorScheme.fromSeed(
        seedColor: GetThemeColor(weatherCondition),
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        hintStyle: GoogleFonts.poppins(color: Colors.white54),
      ),
    );
  }
}

MaterialColor GetThemeColor(String? condition) {
  if (condition == null) {
    return _createMaterialColor(const Color(0xFF3B82F6));
  }
  
  switch (condition.toLowerCase()) {
    case "sunny":
    case "clear":
      return _createMaterialColor(const Color(0xFFFF8C00));
    case "partly cloudy":
      return _createMaterialColor(const Color(0xFF4682B4));
    case "cloudy":
    case "overcast":
      return _createMaterialColor(const Color(0xFF708090));
    case "mist":
    case "fog":
    case "freezing fog":
      return _createMaterialColor(const Color(0xFF87CEEB));
    case "patchy rain possible":
    case "light rain":
    case "moderate rain":
    case "light drizzle":
    case "patchy light drizzle":
      return _createMaterialColor(const Color(0xFF4169E1));
    case "heavy rain":
    case "heavy rain at times":
    case "torrential rain shower":
      return _createMaterialColor(const Color(0xFF191970));
    case "patchy snow possible":
    case "light snow":
    case "moderate snow":
    case "patchy light snow":
    case "patchy moderate snow":
      return _createMaterialColor(const Color(0xFF87CEFA));
    case "heavy snow":
    case "patchy heavy snow":
    case "blizzard":
    case "blowing snow":
      return _createMaterialColor(const Color(0xFF4682B4));
    case "thundery outbreaks possible":
    case "patchy light rain with thunder":
    case "moderate or heavy rain with thunder":
    case "patchy light snow with thunder":
    case "moderate or heavy snow with thunder":
      return _createMaterialColor(const Color(0xFF800080));
    case "freezing drizzle":
    case "heavy freezing drizzle":
    case "light freezing rain":
    case "moderate or heavy freezing rain":
    case "patchy freezing drizzle possible":
      return _createMaterialColor(const Color(0xFF20B2AA));
    case "light sleet":
    case "moderate or heavy sleet":
    case "patchy sleet possible":
    case "light sleet showers":
    case "moderate or heavy sleet showers":
      return _createMaterialColor(const Color(0xFF4169E1));
    case "ice pellets":
    case "light showers of ice pellets":
    case "moderate or heavy showers of ice pellets":
      return _createMaterialColor(const Color(0xFF6495ED));
    case "light rain shower":
    case "moderate or heavy rain shower":
      return _createMaterialColor(const Color(0xFF4169E1));
    case "light snow showers":
    case "moderate or heavy snow showers":
      return _createMaterialColor(const Color(0xFF87CEEB));
    default:
      return _createMaterialColor(const Color(0xFF3B82F6));
  }
}

MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}




