import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static String baseUrl = "http://172.20.130.32:8000";

  // ---------------- OVERVIEW ----------------
  static Future<Map<String, dynamic>> getOverview() async {
    final response = await http.get(Uri.parse("$baseUrl/overview"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load overview");
    }
  }

  // ---------------- PATIENT LIST ----------------
  static Future<List<dynamic>> getPatients() async {
    final response = await http.get(Uri.parse("$baseUrl/patients"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load patients");
    }
  }

  // 🔥 FIXED: ID IS STRING NOW
  static Future<Map<String, dynamic>> getPatientDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/patient/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Patient not found");
    }
  }
}