import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class InsightScreen extends StatefulWidget {
  final String patientId;

  const InsightScreen({super.key, required this.patientId});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {

  List trend = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTrend();
  }

  void loadTrend() async {
    try {
      final data = await ApiService.getPatientTrend(widget.patientId);
      setState(() {
        trend = data;
        loading = false;
      });
    } catch (e) {
      loading = false;
      setState(() {});
    }
  }

  List<FlSpot> buildSpots() {
    List<FlSpot> spots = [];

    for (int i = 0; i < trend.length; i++) {
      final value = (trend[i]["mean_glu_mean_30"] as num?)?.toDouble();

      if (value != null) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (trend.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No visualization available for patient")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Patient ${widget.patientId} Insights")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "30-Day Average Glucose Trend",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: LineChart(
                LineChartData(
                  minY: 60,
                  maxY: 250,
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),

                  lineBarsData: [
                    LineChartBarData(
                      spots: buildSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}