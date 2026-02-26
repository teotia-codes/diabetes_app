import 'package:flutter/material.dart';

class SelectedPatient extends ChangeNotifier {

  String? patientId;

  void setPatient(String id) {
    patientId = id;
    notifyListeners();
  }
}