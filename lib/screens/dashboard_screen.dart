import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'patients_screen.dart';

class DashboardScreen extends StatefulWidget {
const DashboardScreen({super.key});

@override
State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

Map<String, dynamic>? overview;
bool loading = true;

@override
void initState() {
super.initState();
loadOverview();
}

Future<void> loadOverview() async {
final data = await ApiService.getOverview();
setState(() {
overview = data;
loading = false;
});
}

Widget kpiCard(String title, String value, Color color, IconData icon) {
return Container(
margin: const EdgeInsets.only(bottom: 18),
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(22),
gradient: LinearGradient(
colors: [
color.withOpacity(0.18),
color.withOpacity(0.05),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: Row(
children: [
CircleAvatar(
radius: 26,
backgroundColor: color.withOpacity(0.25),
child: Icon(icon, color: color, size: 28),
),
const SizedBox(width: 18),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(title,
),
const SizedBox(height: 6),
Text(value,
),
],
),
)
],
),
);
}

Widget alertBanner() {
int highRisk = overview!["high_risk_count"];


if (highRisk == 0) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        Icon(Icons.verified, color: Colors.green.shade700),
        const SizedBox(width: 12),
        const Text("No high-risk patients today 🎉")
      ],
    ),
  );
}

return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(16)),
  child: Row(
    children: [
      Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
      const SizedBox(width: 12),
      Text("$highRisk high-risk patients need attention",
          style: const TextStyle(fontWeight: FontWeight.bold))
    ],
  ),
);

}

@override
Widget build(BuildContext context) {


if (loading) {
  return const Scaffold(
      body: Center(child: CircularProgressIndicator()));
}

return Scaffold(
  backgroundColor: const Color(0xfff5f7fb),

  body: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Text(
            "Diabetes Risk Monitor",
            style: TextStyle(fontSize: 28,
            fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            "90-day deterioration prediction",
             style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.bold)
          ),

          const SizedBox(height: 20),

          /// ALERT PANEL
          alertBanner(),

          const SizedBox(height: 24),

          /// KPI SECTION
          Text("Overview"
              ),

          const SizedBox(height: 14),

          kpiCard(
              "Total Patients",
              overview!["total_patients"].toString(),
              Colors.blue,
              Icons.people_alt),

          kpiCard(
              "Median Risk Score",
              overview!["median_risk"].toStringAsFixed(2),
              Colors.orange,
              Icons.show_chart),

          kpiCard(
              "High-Risk Patients",
              overview!["high_risk_count"].toString(),
              Colors.red,
              Icons.health_and_safety),

          const SizedBox(height: 28),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PatientsScreen()));
              },
              child: const Text(
                "Open Patient Triage",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    ),
  ),
);


}
}
