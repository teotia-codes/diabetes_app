import 'package:diabetes_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
runApp(const DiabetesApp());
}

class DiabetesApp extends StatelessWidget {
const DiabetesApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Diabetes Risk Monitor',
theme: ThemeData(
primarySwatch: Colors.indigo,
scaffoldBackgroundColor: const Color(0xfff5f7fb),
appBarTheme: const AppBarTheme(
elevation: 0,
backgroundColor: Colors.white,
foregroundColor: Colors.black,
),
),

  // 👇 THIS is your starting screen
  home: const HomeScreen(),
);


}
}
