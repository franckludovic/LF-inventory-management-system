import 'package:get/get.dart';

class ReportDetailsController extends GetxController {
  // Sample data for the report
  final RxString reportPeriod = 'Jan 01 - Jan 07, 2026'.obs;
  final RxInt totalAdditions = 45.obs;
  final RxInt totalRemovals = 12.obs;

  // Sample activity data
  final RxList<Map<String, dynamic>> activities = <Map<String, dynamic>>[
    {
      'date': '02 Jan',
      'part': 'Brake Pad X1',
      'location': 'Van 04',
      'type': 'Added',
      'qty': '+12',
      'by': 'J.D.',
    },
    {
      'date': '03 Jan',
      'part': 'Door Sensor Pro',
      'location': 'Warehouse A',
      'type': 'Removed',
      'qty': '-04',
      'by': 'S.M.',
    },
    {
      'date': '04 Jan',
      'part': 'Main Cable 50m',
      'location': 'Van 12',
      'type': 'Added',
      'qty': '+02',
      'by': 'J.D.',
    },
    {
      'date': '05 Jan',
      'part': 'LED Panel Kit',
      'location': 'Site 88',
      'type': 'Removed',
      'qty': '-01',
      'by': 'T.K.',
    },
    {
      'date': '07 Jan',
      'part': 'Guide Shoe Set',
      'location': 'Van 04',
      'type': 'Added',
      'qty': '+08',
      'by': 'J.D.',
    },
  ].obs;

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
