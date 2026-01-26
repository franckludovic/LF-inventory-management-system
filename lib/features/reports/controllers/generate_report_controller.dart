import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/models/report_model.dart';
import '../../../core/utils/error_handler.dart';
import '../services/reports_service.dart';
import '../../../core/controllers/user_controller.dart';

class GenerateReportController extends GetxController {
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;
  var searchQuery = ''.obs;
  var selectedFilter = 'All Reports'.obs;
  var selectedReportType = 'Weekly Stock Activity Report'.obs;
  var selectedPartName = 'All Parts'.obs;
  var isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController technicianNameController = TextEditingController();

  final filters = ['All Reports', 'Additions', 'Subtractions'];
  final reportTypes = ['Weekly Stock Activity Report', 'Monthly Summary', 'Part-Specific Report', 'Technician Report'];
  final partNames = ['All Parts', 'Sensor A', 'Cable B', 'Board C'];
  final ReportsService _reportsService = ReportsService();
  final UserController _userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    loadReports();
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

  void generateReport() {
    // Generate and download report
    Get.snackbar('Generate Report', 'Report generation feature coming soon');
  }

  void onGenerateReportPressed() {
    // Generate and download report
    Get.snackbar('Generate Report', 'Report generation feature coming soon');
  }
}
