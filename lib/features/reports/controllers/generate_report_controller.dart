import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/models/report_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/error_handler.dart';
import '../services/reports_service.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../features/Parts/services/parts_service.dart';

class GenerateReportController extends GetxController {
  // ─────────────────── State ───────────────────
  final reports = <ReportModel>[].obs;

  final selectedReportType = 'Weekly Stock Activity Report'.obs;
  final selectedPartName = 'All Parts'.obs;
  final selectedTechnicianId = ''.obs;

  final technicians = <UserModel>[].obs;
  final partNames = <String>['All Parts'].obs;

  final isLoading = false.obs;

  // ─────────────────── Controllers ───────────────────
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // ─────────────────── Services ───────────────────
  final ReportsService _reportsService = ReportsService();
  final PartsService _partsService = PartsService();
  final UserController _userController = Get.find<UserController>();

  // ─────────────────── Constants ───────────────────
  final reportTypes = const [
    'Weekly Stock Activity Report',
    'Monthly Summary',
    'Part-Specific Report',
    'Technician Report',
  ];

  // ─────────────────── Lifecycle ───────────────────
  @override
  void onInit() {
    super.onInit();
    _setDefaultDates();
    loadTechnicians();
    loadParts();
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  // ─────────────────── Helpers ───────────────────
  void _setDefaultDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    startDateController.text = _formatDate(monday);
    endDateController.text = _formatDate(sunday);
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  // ─────────────────── Loaders ───────────────────
  Future<void> loadTechnicians() async {
    if (!_userController.isAdmin) return;

    try {
      final list = await _reportsService.getTechnicians();
      technicians.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', ErrorHandler.getErrorMessage(e));
    }
  }

  Future<void> loadParts() async {
    try {
      final parts = await _partsService.getAllParts(
        _userController.accessToken.value,
      );
      final names = ['All Parts', ...parts.map((p) => p['designation'] as String)];
      partNames.assignAll(names);
    } catch (_) {
      partNames.assignAll(['All Parts', 'Sensor A', 'Cable B', 'Board C']);
    }
  }

  Future<void> loadReports() async {
    await loadTechnicians();
    await loadParts();
  }

  // ─────────────────── Setters ───────────────────
  void updateSelectedReportType(String? value) {
    selectedReportType.value = value ?? reportTypes.first;
  }

  void updateSelectedPartName(String? value) {
    selectedPartName.value = value ?? 'All Parts';
  }

  void updateSelectedTechnicianId(String? value) {
    selectedTechnicianId.value = value ?? '';
  }

  // ─────────────────── Core Logic ───────────────────
  Future<void> generateReport() async {
    try {
      isLoading.value = true;

      // ── Validate dates
      final startDate = DateTime.tryParse(startDateController.text);
      final endDate = DateTime.tryParse(endDateController.text);

      if (startDate == null || endDate == null) {
        Get.snackbar('Error', 'Invalid date format');
        return;
      }

      if (startDate.isAfter(endDate)) {
        Get.snackbar('Error', 'Start date cannot be after end date');
        return;
      }

      final isAdmin = _userController.isAdmin;

      if (!isAdmin && selectedTechnicianId.value.isNotEmpty) {
        Get.snackbar(
          'Error',
          'Technicians can only generate their own reports',
        );
        return;
      }

      // ── Fetch logs
      List<dynamic> logsData;

      if (isAdmin) {
        logsData = await _reportsService.getLogsByDateAdmin(
          startDate,
          endDate,
        );

        if (selectedTechnicianId.value.isNotEmpty) {
          logsData = logsData
              .where(
                (log) =>
                    log['utilisateur']?['id'] ==
                    selectedTechnicianId.value,
              )
              .toList();
        }
      } else {
        logsData = await _reportsService.getLogsByDateTechnician(
          startDate,
          endDate,
        );
      }

      // ── Apply part filter
      if (selectedPartName.value != 'All Parts') {
        logsData = logsData
            .where(
              (log) =>
                  log['composant']?['designation'] ==
                  selectedPartName.value,
            )
            .toList();
      }

      if (logsData.isEmpty) {
        Get.snackbar('No Data', 'No logs found for the selected criteria');
        return;
      }

      // ── Navigate to preview/details
      Get.toNamed(
        '/report-details',
        arguments: {
          'logsData': logsData,
          'startDate': startDate,
          'endDate': endDate,
          'reportType': selectedReportType.value,
        },
      );
    } catch (e) {
      Get.snackbar('Error', ErrorHandler.getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
}