import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweathercubit.dart';
import 'package:weatherapp/Models/WeatherModel.dart';

class InfoScreenWeather extends StatelessWidget {
  const InfoScreenWeather({super.key});

  @override
  Widget build(BuildContext context) {
    Weather_Model weather = BlocProvider.of<GetweatherCubit>(context).weatherModel!;
    
    // Split the date string into date and time
    List<String> dateTimeParts = weather.Date.split(' ');
    String date = dateTimeParts.length > 0 ? dateTimeParts[0] : weather.Date;
    String time = dateTimeParts.length > 1 ? dateTimeParts[1] : '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weather Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 18),
            ),
            onPressed: () {
              // Refresh weather data
              final cubit = BlocProvider.of<GetweatherCubit>(context);
              cubit.getWeather(cityName: weather.CityName);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: _getWeatherGradient(weather.WeatherCondition),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Main Weather Card
                _buildMainWeatherCard(weather, date, time)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 25),
                
                // Temperature Range Card
                _buildTemperatureRangeCard(weather)
                    .animate(delay: 150.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: 0.3, end: 0),
                
                const SizedBox(height: 25),
                
                // Quick Stats Row
                _buildQuickStatsRow(weather)
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
                
                const SizedBox(height: 25),
                
                // Detailed Information Grid
                _buildDetailedInfoGrid(weather)
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 25),
                
                // Weather Conditions Card
                _buildWeatherConditionsCard(weather)
                    .animate(delay: 500.ms)
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                
                const SizedBox(height: 25),
                
                // Additional Details
                _buildAdditionalDetails(weather, time)
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 25),
                
                // Weather Tips Card
                _buildWeatherTipsCard(weather)
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainWeatherCard(Weather_Model weather, String date, String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weather Icon and Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temperature and City
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.CityName,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(date),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    if (time.isNotEmpty)
                      Text(
                        _formatTime(time),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Weather Icon
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  _getWeatherEmoji(weather.WeatherCondition),
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Temperature
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weather.Temp.round()}',
                style: GoogleFonts.poppins(
                  fontSize: 80,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 0.8,
                ),
              ),
              Text(
                '°C',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Weather Condition
          Text(
            weather.WeatherCondition,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 25),
          
          // Feels Like
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              'Feels like ${weather.Temp.round()}°C',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureRangeCard(Weather_Model weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTempItem(
            icon: Icons.keyboard_arrow_up_rounded,
            label: 'High',
            value: '${weather.Max_Temp.round()}°C',
            color: Colors.orange,
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildTempItem(
            icon: Icons.device_thermostat_rounded,
            label: 'Current',
            value: '${weather.Temp.round()}°C',
            color: Colors.blue,
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildTempItem(
            icon: Icons.keyboard_arrow_down_rounded,
            label: 'Low',
            value: '${weather.Min_Temp.round()}°C',
            color: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget _buildTempItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow(Weather_Model weather) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            icon: Icons.visibility_outlined,
            label: 'Visibility',
            value: '10 km',
            gradient: [Colors.blue.withOpacity(0.3), Colors.cyan.withOpacity(0.1)],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildQuickStatCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '65%',
            gradient: [Colors.green.withOpacity(0.3), Colors.teal.withOpacity(0.1)],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildQuickStatCard(
            icon: Icons.air_outlined,
            label: 'Wind',
            value: '12 km/h',
            gradient: [Colors.purple.withOpacity(0.3), Colors.indigo.withOpacity(0.1)],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: gradient),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInfoGrid(Weather_Model weather) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _buildDetailCard(
          icon: Icons.compress_outlined,
          title: 'Pressure',
          value: '1013',
          unit: 'hPa',
          subtitle: 'Atmospheric pressure',
        ),
        _buildDetailCard(
          icon: Icons.wb_sunny_outlined,
          title: 'UV Index',
          value: '3',
          unit: '',
          subtitle: _getUVDescription(3),
        ),
        _buildDetailCard(
          icon: Icons.wb_twilight_outlined,
          title: 'Sunrise',
          value: '6:30',
          unit: 'AM',
          subtitle: 'Today',
        ),
        _buildDetailCard(
          icon: Icons.nights_stay_outlined,
          title: 'Sunset',
          value: '7:45',
          unit: 'PM',
          subtitle: 'Today',
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherConditionsCard(Weather_Model weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                'Weather Conditions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildConditionItem(
                  icon: Icons.thermostat_outlined,
                  label: 'Real Feel',
                  value: '${weather.Temp.round()}°C',
                ),
              ),
              Expanded(
                child: _buildConditionItem(
                  icon: Icons.remove_red_eye_outlined,
                  label: 'Visibility',
                  value: '10 km',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildConditionItem(
                  icon: Icons.speed_outlined,
                  label: 'Wind Speed',
                  value: '12 km/h',
                ),
              ),
              Expanded(
                child: _buildConditionItem(
                  icon: Icons.navigation_outlined,
                  label: 'Wind Dir',
                  value: 'NE',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails(Weather_Model weather, String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                'Weather Summary',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('📍 Location', weather.CityName),
          _buildSummaryRow('🕐 Last Updated', _formatTime(time.isNotEmpty ? time : '00:00:00')),
          _buildSummaryRow('🌤️ Condition', weather.WeatherCondition),
          _buildSummaryRow('🌡️ Range', 
              '${weather.Min_Temp.round()}°C - ${weather.Max_Temp.round()}°C'),
          _buildSummaryRow('💨 Wind', 'Light breeze from northeast'),
        ],
      ),
    );
  }

  Widget _buildWeatherTipsCard(Weather_Model weather) {
    List<String> tips = _getWeatherTips(weather.WeatherCondition, weather.Temp);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                'Weather Tips',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      List<String> months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      List<String> weekdays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];
      return "${weekdays[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}";
    } catch (e) {
      return date;
    }
  }

  String _formatTime(String time) {
    try {
      List<String> timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return "$hour:${timeParts[1]} $period";
    } catch (e) {
      return time;
    }
  }

  List<String> _getWeatherTips(String condition, double temp) {
    List<String> tips = [];
    
    // Temperature-based tips
    if (temp > 30) {
      tips.add("Stay hydrated and wear light, breathable clothing");
      tips.add("Limit outdoor activities during peak sun hours");
    } else if (temp < 10) {
      tips.add("Bundle up in warm layers and protect exposed skin");
      tips.add("Be cautious of icy conditions on roads and walkways");
    } else {
      tips.add("Perfect weather for outdoor activities");
    }

    // Condition-based tips
    switch (condition.toLowerCase()) {
      case "sunny":
      case "clear":
        tips.add("Don't forget sunscreen and sunglasses");
        tips.add("Great day for outdoor sports and activities");
        break;
      case "cloudy":
      case "partly cloudy":
        tips.add("Comfortable conditions for most outdoor activities");
        tips.add("Keep a light jacket handy for temperature changes");
        break;
      case "rainy":
      case "light rain":
        tips.add("Carry an umbrella and wear waterproof clothing");
        tips.add("Drive carefully and allow extra travel time");
        break;
      default:
        tips.add("Check weather updates regularly");
        tips.add("Plan indoor alternatives if needed");
    }

    return tips;
  }

  LinearGradient _getWeatherGradient(String condition) {
    switch (condition.toLowerCase()) {
      case "sunny":
      case "clear":
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C00), Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      case "partly cloudy":
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4682B4), Color(0xFF87CEEB), Color(0xFFB0E0E6)],
        );
      case "cloudy":
      case "overcast":
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF708090), Color(0xFF778899), Color(0xFF696969)],
        );
      case "rainy":
      case "light rain":
      case "moderate rain":
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4169E1), Color(0xFF6495ED), Color(0xFF87CEFA)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
        );
    }
  }

  String _getWeatherEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case "sunny":
      case "clear":
        return "☀️";
      case "partly cloudy":
        return "⛅";
      case "cloudy":
      case "overcast":
        return "☁️";
      case "mist":
      case "fog":
        return "🌫️";
      case "patchy rain possible":
      case "light rain":
      case "moderate rain":
      case "light drizzle":
        return "🌦️";
      case "heavy rain":
      case "torrential rain shower":
        return "🌧️";
      case "patchy snow possible":
      case "light snow":
      case "moderate snow":
        return "🌨️";
      case "heavy snow":
      case "blizzard":
        return "❄️";
      case "thundery outbreaks possible":
      case "thunder":
        return "⛈️";
      default:
        return "🌤️";
    }
  }

  String _getUVDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low risk';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High risk';
    if (uvIndex <= 10) return 'Very high';
    return 'Extreme';
  }
}
