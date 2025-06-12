import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weatherapp/Cubits/Get%20weather%20Cubit/Getweathercubit.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
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
    _cityController.dispose();
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
      leading: Container(
        margin: const EdgeInsets.all(8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        '🔍 Search Location',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
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
                const Color(0xFFDBEAFE),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
            padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSearchCard(),
                  const SizedBox(height: 30),
                  _buildLocationButton(),
                  const SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200,
      borderRadius: 25,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.2),
                      ],
                    ),
                    child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter City Name',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 20),
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                      ),
                      child: TextField(
                        controller: _cityController,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                        decoration: InputDecoration(
                  hintText: 'e.g., New York, London, Tokyo...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.location_city_rounded,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  suffixIcon: _isLoading
                      ? Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: _searchWeather,
                          icon: Icon(
                            Icons.search_rounded,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (_) => _searchWeather(),
              ),
            ).animate().scale(delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.2),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isLoading ? null : _getCurrentLocation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.my_location_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Use Current Location',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(delay: 600.ms);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Text(
            '🌟 Powered by Advanced Weather API',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ).animate().fadeIn(delay: 800.ms),
        
        const SizedBox(height: 10),
        
        Text(
          'Get accurate weather forecasts for any location worldwide',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 1000.ms),
      ],
    );
  }

  Future<void> _searchWeather() async {
    if (_cityController.text.trim().isEmpty) {
      _showSnackBar('Please enter a city name', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      var weatherCubit = BlocProvider.of<GetweatherCubit>(context);
      await weatherCubit.getWeather(cityName: _cityController.text.trim());
      
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Weather data loaded successfully!', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Failed to fetch weather data. Please try again.', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permission denied', Colors.red);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied', Colors.red);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get city name from coordinates
      String? city = await getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (city != null) {
        setState(() {
          _cityController.text = city;
        });

        var weatherCubit = BlocProvider.of<GetweatherCubit>(context);
        await weatherCubit.getWeather(cityName: city);
        
        if (mounted) {
          Navigator.pop(context);
          _showSnackBar('Location detected: $city', Colors.green);
        }
      } else {
        _showSnackBar('Could not determine your location', Colors.orange);
      }
    } catch (e) {
      _showSnackBar('Failed to get current location', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    return placemarks.first.locality;
    } catch (e) {
      return null;
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}
