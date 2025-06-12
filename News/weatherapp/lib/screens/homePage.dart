import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweathercubit.dart';
import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweatherstates.dart';
import 'package:weatherapp/Models/WeatherModel.dart';
import 'package:weatherapp/screens/InfoScreenWeather.dart';
import 'package:weatherapp/screens/Search.dart';
import 'package:weatherapp/screens/TextNoView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(),
      body: _buildAnimatedBackground(),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      title: Text(
        '🌤️ Weather Forecast',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideX(),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const SearchView(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ).animate().scale(delay: 300.ms),
      ],
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_backgroundAnimation.value * 2 * 3.14159),
              colors: [
                const Color(0xFF1E3A8A),
                const Color(0xFF3B82F6),
                const Color(0xFF60A5FA),
                const Color(0xFF93C5FD),
              ],
            ),
          ),
          child: BlocBuilder<GetweatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is NoWeatherState) {
                return const TextNoView();
              } else if (state is WeatherLoadingState) {
                return _buildLoadingState();
              } else if (state is WeatherLoadedState) {
                return _buildWeatherHomeContent(state.model);
              } else if (state is FailerState) {
                return _buildErrorState(state.errorMessage ?? 'Something went wrong');
              } else {
                return _buildErrorState('Unknown error occurred');
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildWeatherHomeContent(Weather_Model weather) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Main Weather Card
            _buildMainWeatherCard(weather)
                .animate()
                .fadeIn(duration: 800.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 25),
            
            // Quick Weather Info Row
            _buildQuickInfoRow(weather)
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 25),
            
            // Temperature Details Card
            _buildTemperatureCard(weather)
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 25),
            
            // Action Buttons
            _buildActionButtons(weather)
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWeatherCard(Weather_Model weather) {
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
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // City Name
          Text(
            weather.CityName,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 15),
          
          // Date
          Text(
            _formatDate(weather.Date),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Weather Icon and Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Text(
                  _getWeatherEmoji(weather.WeatherCondition),
                  style: const TextStyle(fontSize: 70),
                ),
              ),
              
              const SizedBox(width: 30),
              
              // Temperature
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.Temp.round()}',
                        style: GoogleFonts.poppins(
                          fontSize: 64,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          height: 0.8,
                        ),
                      ),
                      Text(
                        '°C',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    weather.WeatherCondition,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoRow(Weather_Model weather) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickInfoCard(
            icon: Icons.thermostat_outlined,
            label: 'Feels Like',
            value: '${weather.Temp.round()}°C',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildQuickInfoCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '65%',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildQuickInfoCard(
            icon: Icons.air_outlined,
            label: 'Wind',
            value: '12 km/h',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard(Weather_Model weather) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temperature Range',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTempItem(
                icon: Icons.keyboard_arrow_up_rounded,
                label: 'High',
                value: '${weather.Max_Temp.round()}°C',
                color: Colors.red,
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
                color: Colors.orange,
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

  Widget _buildActionButtons(Weather_Model weather) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.info_outline_rounded,
            label: 'View Details',
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const InfoScreenWeather(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionButton(
            icon: Icons.search_rounded,
            label: 'Search City',
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SearchView(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.1),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.15),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ).animate().scale(duration: 600.ms),
          const SizedBox(height: 25),
          Text(
            'Loading Weather...',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 10),
          Text(
            'Please wait while we fetch the latest data',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    bool isApiKeyError = message.toLowerCase().contains('api key') || message.toLowerCase().contains('invalid');
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  isApiKeyError ? Colors.orange.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                  isApiKeyError ? Colors.yellow.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                ],
              ),
            ),
            child: Icon(
              isApiKeyError ? Icons.key_off_rounded : Icons.error_outline_rounded,
              size: 80,
              color: Colors.white,
            ),
          ).animate().scale(duration: 600.ms),
          const SizedBox(height: 20),
          Text(
            isApiKeyError ? 'API Key Required' : 'Oops! Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isApiKeyError 
                ? 'To use this weather app, you need a free API key from WeatherAPI.com'
                : message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 500.ms),
          ),
          const SizedBox(height: 30),
          if (isApiKeyError) 
            _buildApiKeyInstructions()
          else
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ).animate().scale(delay: 700.ms),
        ],
      ),
    );
  }

  Widget _buildApiKeyInstructions() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Text(
                'How to get your free API key:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              _buildStep('1', 'Visit weatherapi.com'),
              _buildStep('2', 'Click "Sign Up Free"'),
              _buildStep('3', 'Verify your email'),
              _buildStep('4', 'Copy your API key'),
              _buildStep('5', 'Update the app code'),
            ],
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Column(
            children: [
              Text(
                'Replace the API key in:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'lib/Cubits/Get weather Cubit/Getweathercubit.dart',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  } 
          
  Widget _buildStep(String number, String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              instruction,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr.split(' ')[0]);
      List<String> months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      List<String> weekdays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];
      return "${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}";
    } catch (e) {
      return dateStr;
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
}
  
  // create States
  // create cubit
  //create function 
  // provide cubit
  // intgrate cubit
  // trigger cubit 