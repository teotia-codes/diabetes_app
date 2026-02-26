import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'patients_screen.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int currentIndex = 0;

final pages = const [
DashboardScreen(),
PatientsScreen(),

];

@override
Widget build(BuildContext context) {
return Scaffold(
body: pages[currentIndex],


  bottomNavigationBar: NavigationBar(
    height: 70,
    selectedIndex: currentIndex,
    onDestinationSelected: (index) {
      setState(() => currentIndex = index);
    },
    destinations: const [
      NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          label: "Overview"),
      NavigationDestination(
          icon: Icon(Icons.people_outline),
          label: "Patients"),
      NavigationDestination(
          icon: Icon(Icons.psychology_outlined),
          label: "Insights"),
    ],
  ),
);


}
}
