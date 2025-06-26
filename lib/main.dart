import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:museum_ar_guide/core/theme/app_theme.dart';
import 'package:museum_ar_guide/screens/ar_screen.dart';
import 'package:museum_ar_guide/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/artwork_provider.dart';
import 'providers/museum_provider.dart';
import 'providers/user_provider.dart';
import 'providers/visited_artwork_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArtworkProvider()),
        ChangeNotifierProvider(create: (_) => MuseumProvider()),
        ChangeNotifierProvider(create: (_) => VisitedArtworkProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'MüzAR',
        theme: appTheme, // Light theme
        darkTheme: appDarkTheme, // <--- Dark theme burada!
        themeMode: ThemeMode.system, // Sistem temasına uyar (auto dark/light)
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
