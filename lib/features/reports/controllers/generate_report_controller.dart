import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GenerateReportController extends GetxController {
  // Observable variables for state management
  var selectedReportType = Rx<String?>(null);
  var startDateController = TextEditingController(text: '10/01/2023').obs;
  var endDateController = TextEditingController(text: '10/07/2023').obs;
  var technicianNameController = TextEditingController().obs;
  var selectedPartName = Rx<String?>(null);

  // Report types list
  final List<String> reportTypes = [
    'Weekly Stock Activity Report',
    'Monthly Summary',
    'Technician Usage Report',
    'Low Stock Alerts',
  ];

  // Part names list
  final List<String> partNames = [
    'All',
    'Traction Cable',
    'Door Roller Assembly',
    'Emergency Light Battery',
    'Main Control PCB',
    'Overspeed Governor',
  ];

  // Methods for updating state
  void updateSelectedReportType(String? value) {
    selectedReportType.value = value;
  }

  void updateSelectedPartName(String? value) {
    selectedPartName.value = value;
  }

  // Method to generate report
  void generateReport() {
    Get.toNamed('/report-details');
  }

  // Cleanup method
  @override
  void onClose() {
    startDateController.value.dispose();
    endDateController.value.dispose();
    technicianNameController.value.dispose();
    super.onClose();
  }
}
