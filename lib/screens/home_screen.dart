import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/selected_patient.dart';
import '../services/app_navigation.dart';
import 'dashboard_screen.dart';
import 'patients_screen.dart';
import 'insight_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final nav = context.watch<AppNavigation>();
    final selectedPatient = context.watch<SelectedPatient>().patientId;

    final pages = [
      const DashboardScreen(),
      const PatientsScreen(),
      selectedPatient == null
          ? const _NoPatientSelected()
          : InsightScreen(patientId: selectedPatient),
    ];

    return Scaffold(
      body: pages[nav.currentIndex],

      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: nav.currentIndex,
        onDestinationSelected: (index) {
          context.read<AppNavigation>().goTo(index);
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

class _NoPatientSelected extends StatelessWidget {
  const _NoPatientSelected();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Select a patient first to view AI insights",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}