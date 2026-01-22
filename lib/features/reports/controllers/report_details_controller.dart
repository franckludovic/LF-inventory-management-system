import 'package:get/get.dart';
import '../../../core/models/report_model.dart';

class ReportDetailsController extends GetxController {
  final ReportModel report;

  ReportDetailsController({required this.report});

  // Report data
  final RxString reportPeriod = ''.obs;
  final RxInt totalAdditions = 0.obs;
  final RxInt totalRemovals = 0.obs;

  // Activity data based on the report
  final RxList<Map<String, dynamic>> activities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReportData();
  }

  void loadReportData() {
    reportPeriod.value = 'Report for ${report.createdAt.toString()}';
    totalAdditions.value = report.type.toLowerCase() == 'added' ? report.quantity : 0;
    totalRemovals.value = report.type.toLowerCase() == 'removed' ? report.quantity : 0;

    activities.assignAll([
      {
        'date': report.createdAt.toString(),
        'part': report.partName,
        'location': report.locationName,
        'type': report.type,
        'qty': '${report.type == 'ADDED' ? '+' : '-'}${report.quantity}',
        'by': report.userName,
      },
    ]);
  }

  void exportPDF() {
    // TODO: Implement PDF export
    Get.snackbar('Export', 'PDF export functionality coming soon!');
  }

  void exportCSV() {
    // TODO: Implement CSV export
    Get.snackbar('Export', 'CSV export functionality coming soon!');
  }

  void backToDashboard() {
    Get.back();
  }
}
