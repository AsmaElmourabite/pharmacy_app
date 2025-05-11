import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'utils/theme.dart';
import 'services/app_state.dart';
import 'screens/pharmacist/pharmacist_home_screen.dart';
import 'screens/supplier/supplier_home_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const PharmacyApp(),
    ),
  );
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmacieConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/pharmacist_home': (context) => const PharmacistHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
      },
    );
  }
}



