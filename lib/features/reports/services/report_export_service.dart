import 'dart:io';
import 'package:lf_project/core/constants/strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class ReportExportService {
  // ─────────────────── PDF EXPORT ───────────────────
  Future<void> exportPDF({
    required List<Map<String, dynamic>> activities,
    required String reportPeriod,
    required int totalAdditions,
    required int totalRemovals,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            AppStrings.stockActivityReportTitle,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('${AppStrings.periodLabel} $reportPeriod'),
          pw.Text('${AppStrings.generatedOn} ${_today()}'),
          pw.SizedBox(height: 8),
          pw.Text('${AppStrings.totalAdditionsLabel} $totalAdditions'),
          pw.Text('${AppStrings.totalRemovalsLabel} $totalRemovals'),
          pw.Text('${AppStrings.totalRecordsLabel} ${activities.length}'),
          pw.SizedBox(height: 16),

          pw.Table.fromTextArray(
            headers: [
              AppStrings.dateHeader,
              AppStrings.partHeader,
              AppStrings.typeHeader,
              AppStrings.qtyHeader,
              AppStrings.byHeader,
              AppStrings.locationHeader,
            ],
            data: activities.map((a) {
              return [
                a['date'] ?? '-',
                a['part'] ?? '-',
                a['type'] ?? '-',
                a['qty'].toString(),
                a['by'] ?? '-',
                a['location'] ?? '-',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
    );
  }

  // ─────────────────── CSV EXPORT ───────────────────
  Future<File> exportCSV(
    List<Map<String, dynamic>> activities,
  ) async {
    final rows = <List<String>>[
      [AppStrings.dateHeader, AppStrings.partHeader, AppStrings.typeHeader, AppStrings.qtyHeader, AppStrings.byHeader, AppStrings.locationHeader],
      ...activities.map(
        (a) => [
          a['date'] ?? '-',
          a['part'] ?? '-',
          a['type'] ?? '-',
          a['qty'].toString(),
          a['by'] ?? '-',
          a['location'] ?? '-',
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.csv',
    );

    await file.writeAsString(csv);
    return file;
  }

  // ─────────────────── Helpers ───────────────────
  String _today() {
    final now = DateTime.now();
    return '${now.year}-${_two(now.month)}-${_two(now.day)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}