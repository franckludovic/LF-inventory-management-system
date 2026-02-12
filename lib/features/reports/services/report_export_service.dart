import 'dart:io';
import 'package:lf_project/core/constants/strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';


class ReportExportService {
  // ─────────────────── PDF EXPORT ───────────────────
  Future<bool> exportPDF({
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

    // Note: Printing.layoutPdf opens the system print dialog.
    // It doesn't return whether user actually printed or cancelled.
    // We can only detect if an error occurred.
    try {
      await Printing.layoutPdf(
        onLayout: (_) async => pdf.save(),
      );
      // Since we can't detect cancellation, we return true 
      // only if no exception was thrown (dialog was presented)
      return true;
    } catch (e) {
      return false;
    }
  }

  // ─────────────────── Helpers ───────────────────

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${_two(now.month)}-${_two(now.day)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
