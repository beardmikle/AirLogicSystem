import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/capabilities_screen.dart';
import 'screens/admin_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/session_service.dart';
import 'services/device_db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await SessionService.init();
  await DeviceDbService.init();
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
        '/admin': (context) => const AdminScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}