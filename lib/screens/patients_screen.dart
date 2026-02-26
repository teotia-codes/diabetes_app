import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'patient_detail_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {

  List patients = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  void loadPatients() async {
    try {
      final data = await ApiService.getPatients();
      setState(() {
        patients = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Color riskColor(double risk) {
    if (risk >= 0.6) return Colors.red;
    if (risk >= 0.3) return Colors.orange;
    return Colors.green;
  }

  String riskLabel(double risk) {
    if (risk >= 0.6) return "HIGH";
    if (risk >= 0.3) return "MEDIUM";
    return "LOW";
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patients"),
      ),

      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {

          final patient = patients[index];

          // 🔥 IMPORTANT: ID IS STRING
          final String id = patient["Patient_ID"].toString();

          final double risk =
              (patient["risk"] as num).toDouble();

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),

              title: Text(
                "Patient $id",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(
                "Risk Score: ${risk.toStringAsFixed(2)}",
              ),

              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: riskColor(risk),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  riskLabel(risk),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              onTap: () {
  final String id = patients[index]["Patient_ID"].toString();

  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => PatientDetailScreen(
      id: patients[index]["Patient_ID"],
    ),
  ),
);
},
            ),
          );
        },
      ),
    );
  }
}