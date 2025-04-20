import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'audio_manager.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait mode for better kid experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize audio
  AudioManager.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4A7BF7), // Primary (60%)
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFC107), // Secondary (30%)
          tertiary: const Color(0xFFFF5252),  // Accent (10%)
        ),
        fontFamily: 'ComicNeue',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'BubblegumSans'),
          headlineMedium: TextStyle(fontFamily: 'BubblegumSans'),
          titleLarge: TextStyle(fontFamily: 'BubblegumSans'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF4A7BF7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

