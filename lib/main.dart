import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/livro_crud_screen.dart';

const Color azulPreto = Color(0xFF0A0F1C);
const Color azulProfundo = Color(0xFF1A2439);
const Color azulPetroleo = Color(0xFF223352);
const Color azulAcinzentado = Color(0xFF2F4A6A);
const Color azulSuave = Color(0xFF4A6FA5);
const Color branco = Colors.white;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Livros',
      theme: ThemeData(
        primaryColor: azulProfundo,
        scaffoldBackgroundColor: azulPreto,
        appBarTheme: const AppBarTheme(
          backgroundColor: azulProfundo,
          foregroundColor: branco,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: azulSuave,
          foregroundColor: branco,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: azulSuave,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: branco),
          bodyMedium: TextStyle(color: branco),
          bodySmall: TextStyle(color: branco),
          titleLarge: TextStyle(color: branco),
          titleMedium: TextStyle(color: branco),
          titleSmall: TextStyle(color: branco),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const LivroCrudScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

