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
  Map<String, dynamic>? insightData;
  List<dynamic> trendData = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  void loadAllData() async {
    try {
      final insights =
          await ApiService.getPatientInsights(widget.patientId);

      final trend =
          await ApiService.getPatientTrend(widget.patientId);

      setState(() {
        insightData = insights;
        trendData = trend;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Color riskColor(String level) {
    if (level == "HIGH") return Colors.red;
    if (level == "MEDIUM") return Colors.orange;
    return Colors.green;
  }

List<FlSpot> buildSpots() {
  List<FlSpot> spots = [];

  for (int i = 0; i < trendData.length; i++) {
    final val = trendData[i]["mean_glucose"]; // ✅ correct key

    if (val != null) {
      spots.add(
        FlSpot(i.toDouble(), (val as num).toDouble()),
      );
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

    final String level = insightData?["risk_level"] ?? "UNKNOWN";
    final double risk =
        (insightData?["risk_score"] as num?)?.toDouble() ?? 0.0;

    final List alerts = insightData?["alerts"] ?? [];
    final List insights = insightData?["insights"] ?? [];
    final List actions =
        insightData?["recommended_actions"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("AI Insights - ${widget.patientId}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 Risk Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: riskColor(level).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: riskColor(level), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    "Risk Level: $level",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: riskColor(level)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${(risk * 100).toStringAsFixed(1)}% 90-Day Risk",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 📈 Glucose Trend Graph
            const Text(
              "Glucose Trend (30-day Mean)",
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (trendData.isNotEmpty && buildSpots().isNotEmpty)
              SizedBox(
                height: 250,
                child: LineChart(
  LineChartData(
    minY: 60,
    maxY: 260,

    gridData: FlGridData(
      show: true,
      horizontalInterval: 40,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 1,
        );
      },
    ),

    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey.shade300),
    ),

    titlesData: FlTitlesData(

      // LEFT SIDE (Glucose values)
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
          interval: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),

      // BOTTOM (Days)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 5,
          getTitlesWidget: (value, meta) {
            return Text(
              "Day ${value.toInt() + 1}",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            );
          },
        ),
      ),

      // REMOVE top & right
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),

    lineBarsData: [
      LineChartBarData(
        spots: buildSpots(),
        isCurved: true,
        color: Colors.blue,
        barWidth: 3,

        dotData: FlDotData(show: false),

        belowBarData: BarAreaData(
          show: true,
          color: Colors.blue.withOpacity(0.15),
        ),
      ),
    ],
  ),
)
              )
            else
              const Text("No trend data available"),

            const SizedBox(height: 24),

            /// 🚨 Alerts
            if (alerts.isNotEmpty) ...[
              const Text("Medical Alerts",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...alerts.map((a) => Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.warning,
                          color: Colors.red),
                      title: Text(a.toString()),
                    ),
                  )),
              const SizedBox(height: 24),
            ],

            /// 🧠 AI Insights
            const Text("AI Interpretation",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...insights.map((i) => Card(
                  child: ListTile(
                    leading:
                        const Icon(Icons.psychology_outlined),
                    title: Text(i.toString()),
                  ),
                )),

            const SizedBox(height: 24),

            /// ✅ Actions
            const Text("Recommended Actions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...actions.map((a) => Card(
                  color: Colors.green.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.check_circle,
                        color: Colors.green),
                    title: Text(a.toString()),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}