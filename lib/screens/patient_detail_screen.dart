import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PatientDetailScreen extends StatefulWidget {

  // 🔥 STRING (not int anymore)
  final String id;

  const PatientDetailScreen({super.key, required this.id});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {

  Map<String, dynamic>? patient;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  void loadDetail() async {
    final data = await ApiService.getPatientDetail(widget.id);
    setState(() {
      patient = data;
      loading = false;
    });
  }

  Color riskColor(double risk) {
    if (risk >= 0.6) return Colors.red;
    if (risk >= 0.3) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double risk = patient!["risk"];

    return Scaffold(
      appBar: AppBar(title: Text("Patient ${widget.id}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Predicted Diabetes Risk",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            CircleAvatar(
              radius: 70,
              backgroundColor: riskColor(risk),
              child: Text(
                "${(risk * 100).toStringAsFixed(1)}%",
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            if (patient!["a1c_prior"] != null)
              Text("Previous A1C: ${patient!["a1c_prior"]}"),

            if (patient!["a1c_future"] != null)
              Text("Future A1C: ${patient!["a1c_future"]}"),
          ],
        ),
      ),
    );
  }
}