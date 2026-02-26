import 'package:diabetes_app/services/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/selected_patient.dart';

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

  // ---------------- API CALL ----------------
  void loadPatients() async {
    try {
      final data = await ApiService.getPatients();
      setState(() {
        patients = data;
        loading = false;
      });
    } catch (e) {
      loading = false;
      setState(() {});
    }
  }

  // ---------------- RISK HELPERS ----------------
  Color riskColor(double risk) {
    if (risk >= 0.6) return const Color(0xFFD32F2F); // high
    if (risk >= 0.3) return const Color(0xFFF57C00); // medium
    return const Color(0xFF2E7D32); // low
  }

  String riskLabel(double risk) {
    if (risk >= 0.6) return "HIGH RISK";
    if (risk >= 0.3) return "MODERATE";
    return "LOW RISK";
  }

  // ---------------- UI ----------------
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
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {

          final patient = patients[index];
          final String id = patient["Patient_ID"].toString();
          final double risk = (patient["risk"] as num).toDouble();

          return GestureDetector(
            onTap: () {

  // save selected patient
  context.read<SelectedPatient>().setPatient(id);

  // move to Insights tab automatically
  context.read<AppNavigation>().goTo(2);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Opening AI insights for Patient $id"),
      duration: const Duration(seconds: 1),
    ),
  );
},

            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 2,
                    color: Color(0x22000000),
                    offset: Offset(0, 4),
                  )
                ],
              ),

              child: Row(
                children: [

                  // left risk indicator bar
                  Container(
                    width: 6,
                    height: 70,
                    decoration: BoxDecoration(
                      color: riskColor(risk),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // patient info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Patient $id",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Predicted 90-Day Risk",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 8),

                        LinearProgressIndicator(
                          value: risk,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                          color: riskColor(risk),
                          backgroundColor: Colors.grey.shade200,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${(risk * 100).toStringAsFixed(1)} %",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // risk badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: riskColor(risk),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      riskLabel(risk),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}