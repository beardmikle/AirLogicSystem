import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/capabilities_screen.dart';

void main() {
  runApp(const DiadocApp());
}

class DiadocApp extends StatelessWidget {
  const DiadocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirLogicSystem - Удаленное управление газоанализаторами',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1976D2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
      routes: {
        '/capabilities': (context) => const CapabilitiesScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
