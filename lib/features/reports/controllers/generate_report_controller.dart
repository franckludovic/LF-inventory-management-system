import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/models/report_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/error_handler.dart';
import '../services/reports_service.dart';
import '../services/report_export_service.dart';
import '../../../core/controllers/user_controller.dart';

class GenerateReportController extends GetxController {
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;
  var searchQuery = ''.obs;
  var selectedFilter = 'All Reports'.obs;
  var selectedReportType = 'Weekly Stock Activity Report'.obs;
  var selectedPartName = 'All Parts'.obs;
  var selectedTechnicianId = ''.obs;
  var technicians = <UserModel>[].obs;
  var isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController technicianNameController = TextEditingController();

  final filters = ['All Reports', 'Additions', 'Subtractions'];
  final reportTypes = ['Weekly Stock Activity Report', 'Monthly Summary', 'Part-Specific Report', 'Technician Report'];
  final partNames = ['All Parts', 'Sensor A', 'Cable B', 'Board C'];
  final ReportsService _reportsService = ReportsService();
  final ReportExportService _exportService = ReportExportService();
  final UserController _userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    loadReports();
    loadTechnicians();
    _setupSearchAndFilter();
  }

  Future<void> loadReports() async {
    try {
      isLoading.value = true;
      final isAdmin = _userController.userRole.contains('ROLE_ADMIN');

      List<dynamic> logsData;
      if (isAdmin) {
        logsData = await _reportsService.getAllLogsAdmin();
      } else {
        logsData = await _reportsService.getAllLogsTechnician();
      }

      final reportsList = logsData.map((log) => ReportModel.fromMap(log)).toList();
      reports.assignAll(reportsList);
    } catch (e) {
      Get.snackbar('Error', ErrorHandler.getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _setupSearchAndFilter() {
    everAll([searchQuery, selectedFilter], (_) {
      _filterReports();
    });
  }

  void _filterReports() {
    var filtered = reports.where((report) {
      final matchesSearch = searchQuery.isEmpty ||
          report.partName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          report.userName.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesFilter = selectedFilter.value == 'All Reports' ||
          report.type.toLowerCase().contains(selectedFilter.value.toLowerCase());

      return matchesSearch && matchesFilter;
    }).toList();

    filteredReports.assignAll(filtered);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onFilterSelected(String filter) {
    selectedFilter.value = filter;
  }

  void onReportPressed(ReportModel report) {
    // Navigate to report details
    Get.toNamed('/report-details', arguments: report);
  }

  void updateSelectedReportType(String? value) {
    selectedReportType.value = value ?? 'Weekly Stock Activity Report';
  }

  void updateSelectedPartName(String? value) {
    selectedPartName.value = value ?? '';
  }

  void updateSelectedTechnicianId(String? value) {
    selectedTechnicianId.value = value ?? '';
  }

  Future<void> loadTechnicians() async {
    if (_userController.isAdmin) {
      try {
        final techniciansList = await _reportsService.getTechnicians();
        technicians.assignAll(techniciansList);
      } catch (e) {
        Get.snackbar('Error', ErrorHandler.getErrorMessage(e));
      }
    }
  }

  Future<void> generateReport() async {
    try {
      isLoading.value = true;

      // Validate inputs
      if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
        Get.snackbar('Error', 'Please select both start and end dates');
        return;
      }

      final startDate = DateTime.parse(startDateController.text);
      final endDate = DateTime.parse(endDateController.text);

      if (startDate.isAfter(endDate)) {
        Get.snackbar('Error', 'Start date cannot be after end date');
        return;
      }

      // Role-based access control
      final isAdmin = _userController.isAdmin;
      if (!isAdmin && selectedTechnicianId.value.isNotEmpty) {
        Get.snackbar('Error', 'Technicians can only generate their own reports');
        return;
      }

      // Fetch filtered logs
      List<dynamic> logsData;
      if (isAdmin) {
        if (selectedTechnicianId.value.isNotEmpty) {
          // Admin selecting specific technician - use all logs and filter client-side
          logsData = await _reportsService.getLogsByDateAdmin(startDate, endDate);
          logsData = logsData.where((log) => log['utilisateur']['id'] == selectedTechnicianId.value).toList();
        } else {
          // Admin generating all technicians' reports
          logsData = await _reportsService.getLogsByDateAdmin(startDate, endDate);
        }
      } else {
        // Technician generating own reports
        logsData = await _reportsService.getLogsByDateTechnician(startDate, endDate);
      }

      // Apply part filter if selected
      if (selectedPartName.value != 'All Parts') {
        logsData = logsData.where((log) => log['composant']['designation'] == selectedPartName.value).toList();
      }

      if (logsData.isEmpty) {
        Get.snackbar('No Data', 'No logs found for the selected criteria');
        return;
      }

      // Navigate to report details screen with the data for preview and export
      Get.toNamed('/report-details', arguments: {
        'logsData': logsData,
        'startDate': startDate,
        'endDate': endDate,
        'reportType': selectedReportType.value,
      });
    } catch (e) {
      Get.snackbar('Error', ErrorHandler.getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }



  void onGenerateReportPressed() {
    generateReport();
  }
}
