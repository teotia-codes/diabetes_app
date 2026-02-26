import 'package:diabetes_app/services/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/selected_patient.dart';

void main() {
  runApp(
    MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => SelectedPatient()),
    ChangeNotifierProvider(create: (_) => AppNavigation()),
  ],
  child: const MyApp(),
)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diabetes Risk',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}