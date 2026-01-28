import 'package:get/get.dart';
import '../services/report_export_service.dart';

class ReportDetailsController extends GetxController {
  // Report data from arguments
  late List<dynamic> logsData;
  late DateTime startDate;
  late DateTime endDate;
  late String reportType;

  // Report summary data
  final RxString reportPeriod = ''.obs;
  final RxInt totalAdditions = 0.obs;
  final RxInt totalRemovals = 0.obs;
  final RxInt totalRecords = 0.obs;

  // Activity data based on the logs
  final RxList<Map<String, dynamic>> activities = <Map<String, dynamic>>[].obs;

  final ReportExportService _exportService = ReportExportService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    logsData = args['logsData'];
    startDate = args['startDate'];
    endDate = args['endDate'];
    reportType = args['reportType'];
    loadReportData();
  }

  void loadReportData() {
    reportPeriod.value = 'Period: ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}';
    totalRecords.value = logsData.length;

    // Calculate totals
    totalAdditions.value = logsData.where((log) => log['type'] == 'ADDED').fold(0, (sum, log) => sum + (log['quantite'] as int));
    totalRemovals.value = logsData.where((log) => log['type'] == 'REMOVED').fold(0, (sum, log) => sum + (log['quantite'] as int));

    // Prepare activities list
    activities.assignAll(logsData.map((log) {
      return {
        'date': _safeDate(log['created_at']),
        'part': log['composant']?['designation'] ?? '-',
        'location': log['sac']?['nom'] ?? '-',
        'type': log['type'] ?? '-',
        'qty': '${log['type'] == 'ADDED' ? '+' : '-'}${log['quantite']}',
        'by': log['utilisateur']?['nom'] ?? '-',
      };
    }).toList());
  }

  Future<void> exportPDF() async {
    try {
      await _exportService.generatePDF(
        logsData: logsData,
        startDate: startDate,
        endDate: endDate,
      );
      Get.snackbar('Success', 'PDF report generated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate PDF report');
    }
  }

  Future<void> exportCSV() async {
    try {
      final file = await _exportService.generateCSV(
        logsData: logsData,
      );
      Get.snackbar('Success', 'CSV saved to ${file.path}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate CSV report');
    }
  }

  void backToDashboard() {
    Get.back();
  }

  String _safeDate(dynamic raw) {
    if (raw == null) return '-';
    return raw.toString().split('T').first;
  }
}
