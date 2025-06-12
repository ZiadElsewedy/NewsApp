// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweathercubit.dart';
// import 'package:weatherapp/screens/homePage.dart';

// class Material extends StatelessWidget {
//   const Material({super.key});

//   @override
//   Widget build(BuildContext context) {
// //     return  MaterialApp(
//         theme:ThemeData(
//           primarySwatch: GetThemeColor(BlocProvider.of<GetWeatherCubit>(context)
//           .WeatherModel?.WeatherCondition
//           )
//         ) ,
//         debugShowCheckedModeBanner: false,
//         home: const HomePage(),
//       );
//   }
// }
// MaterialColor GetThemeColor(String? condition) {
//   if (condition == null) {
//     return Colors.blue;
//   }
//   switch (condition) {
//     case "Sunny":
//       return Colors.orange;
//     case "Partly cloudy":
//       return Colors.blueGrey;
//     case "Cloudy":
//       return Colors.grey;
//     case "Overcast":
//       return Colors.blueGrey;
//     case "Mist":
//       return Colors.blue;
//     case "Patchy rain possible":
//       return Colors.lightBlue;
//     case "Patchy snow possible":
//       return Colors.blue;
//     case "Patchy sleet possible":
//       return Colors.indigo;
//     case "Patchy freezing drizzle possible":
//       return Colors.cyan;
//     case "Thundery outbreaks possible":
//       return Colors.deepPurple;
//     case "Blowing snow":
//       return Colors.lightBlue;
//     case "Blizzard":
//       return Colors.blueGrey;
//     case "Fog":
//       return Colors.grey;
//     case "Freezing fog":
//       return Colors.cyan;
//     case "Patchy light drizzle":
//       return Colors.lightBlue;
//     case "Light drizzle":
//       return Colors.lightBlue;
//     case "Freezing drizzle":
//       return Colors.cyan;
//     case "Heavy freezing drizzle":
//       return Colors.cyan;
//     case "Patchy light rain":
//       return Colors.lightBlue;
//     case "Light rain":
//       return Colors.blue;
//     case "Moderate rain at times":
//       return Colors.blue;
//     case "Moderate rain":
//       return Colors.blue;
//     case "Heavy rain at times":
//       return Colors.indigo;
//     case "Heavy rain":
//       return Colors.indigo;
//     case "Light freezing rain":
//       return Colors.cyan;
//     case "Moderate or heavy freezing rain":
//       return Colors.cyan;
//     case "Light sleet":
//       return Colors.blue;
//     case "Moderate or heavy sleet":
//       return Colors.indigo;
//     case "Patchy light snow":
//       return Colors.lightBlue;
//     case "Light snow":
//       return Colors.lightBlue;
//     case "Patchy moderate snow":
//       return Colors.blue;
//     case "Moderate snow":
//       return Colors.blue;
//     case "Patchy heavy snow":
//       return Colors.indigo;
//     case "Heavy snow":
//       return Colors.indigo;
//     case "Ice pellets":
//       return Colors.lightBlue;
//     case "Light rain shower":
//       return Colors.blue;
//     case "Moderate or heavy rain shower":
//       return Colors.blue;
//     case "Torrential rain shower":
//       return Colors.indigo;
//     case "Light sleet showers":
//       return Colors.blue;
//     case "Moderate or heavy sleet showers":
//       return Colors.indigo;
//     case "Light snow showers":
//       return Colors.lightBlue;
//     case "Moderate or heavy snow showers":
//       return Colors.blue;
//     case "Light showers of ice pellets":
//       return Colors.blue;
//     case "Moderate or heavy showers of ice pellets":
//       return Colors.blue;
//     case "Patchy light rain with thunder":
//       return Colors.purple;
//     case "Moderate or heavy rain with thunder":
//       return Colors.deepPurple;
//     case "Patchy light snow with thunder":
//       return Colors.purple;
//     case "Moderate or heavy snow with thunder":
//       return Colors.deepPurple;
//     default:
//       return Colors.blue;
//   }
// }
