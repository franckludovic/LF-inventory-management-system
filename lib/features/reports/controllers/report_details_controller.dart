import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/controllers/navigation_controller.dart';
import '../services/report_export_service.dart';

class ReportDetailsController extends GetxController {
  // ─────────────────── Observables ───────────────────
  final reportPeriod = ''.obs;
  final totalAdditions = 0.obs;
  final totalRemovals = 0.obs;
  final totalRecords = 0.obs;

  final activities = <Map<String, dynamic>>[].obs;

  // ─────────────────── Services ───────────────────
  final ReportExportService _exportService = ReportExportService();

  // ─────────────────── Lifecycle ───────────────────
  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  // ─────────────────── Data Loader ───────────────────
  void _loadArguments() {
    final args = Get.arguments;

    if (args == null || args['logsData'] == null) {
      Get.snackbar('Error', 'No report data provided');
      Get.back();
      return;
    }

    final List logs = args['logsData'];
    final DateTime startDate = args['startDate'];
    final DateTime endDate = args['endDate'];

    _setReportPeriod(startDate, endDate);
    _processLogs(logs);
  }

  void _setReportPeriod(DateTime start, DateTime end) {
    final formatter = DateFormat('dd MMM yyyy');
    reportPeriod.value =
        '${formatter.format(start)} - ${formatter.format(end)}';
  }

  void _processLogs(List logs) {
    int additions = 0;
    int removals = 0;

    final processedActivities = <Map<String, dynamic>>[];

    for (final log in logs) {
      final qty = (log['quantite'] ?? 0) as int;
      final type = log['type'] ?? '';

      // Use quantity sign to determine addition vs removal
      if (qty > 0) {
        additions += qty;
      } else {
        removals += qty.abs();
      }

      // Format the date properly
      String formattedDate = '';
      if (log['created_at'] != null) {
        try {
          final dateTime = DateTime.parse(log['created_at']);
          formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        } catch (e) {
          formattedDate = log['created_at'].toString();
        }
      }

      processedActivities.add({
        'date': formattedDate,
        'part': log['composant']?['designation'] ?? '—',
        'location': log['sac']?['nom'] ?? '—',
        'type': type,
        'qty': qty,
        'by': log['utilisateur']?['nom'] ?? '—',
      });
    }

    totalAdditions.value = additions;
    totalRemovals.value = removals;
    totalRecords.value = processedActivities.length;

    activities.assignAll(processedActivities);
  }

  // ─────────────────── Actions ───────────────────
  Future<void> exportPDF() async {
    try {
      await _exportService.exportPDF(
        activities: activities,
        reportPeriod: reportPeriod.value,
        totalAdditions: totalAdditions.value,
        totalRemovals: totalRemovals.value,
      );

      Get.snackbar('Success', AppStrings.exportPDFSuccess);
    } catch (e) {
      Get.snackbar('Error', 'Failed to export PDF');
    }
  }

  Future<void> exportCSV() async {
    try {
      await _exportService.exportCSV(activities);
      Get.snackbar('Success', AppStrings.exportCSVSuccess);
    } catch (e) {
      Get.snackbar('Error', 'Failed to export CSV');
    }
  }

  void backToDashboard() {
    // Navigate to navigation menu and select dashboard (index 0)
    final NavigationController navController = Get.find<NavigationController>();
    navController.selectedIndex.value = 0;
    Get.offAllNamed('/');
  }
}