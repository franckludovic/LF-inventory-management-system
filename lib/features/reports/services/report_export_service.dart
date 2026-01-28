import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class ReportExportService {
  /// Generate PDF report
  Future<void> generatePDF({
    required List<dynamic> logsData,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Stock Activity Report',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Period: ${_formatDate(startDate)} → ${_formatDate(endDate)}',
              ),
              pw.Text(
                'Generated on: ${_formatDate(DateTime.now())}',
              ),
              pw.Text('Total Records: ${logsData.length}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: const [
                  'Date',
                  'Part',
                  'Type',
                  'Quantity',
                  'User',
                  'Location',
                ],
                data: logsData.map((log) {
                  return [
                    _safeDate(log['created_at']),
                    log['composant']?['designation'] ?? '-',
                    log['type'] ?? '-',
                    log['quantite'].toString(),
                    log['utilisateur']?['nom'] ?? '-',
                    log['sac']?['nom'] ?? '-',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
    );
  }

  /// Generate CSV report
  Future<File> generateCSV({
    required List<dynamic> logsData,
  }) async {
    final csvData = <List<String>>[
      ['Date', 'Part', 'Type', 'Quantity', 'User', 'Location'],
      ...logsData.map((log) => [
            _safeDate(log['created_at']),
            log['composant']?['designation'] ?? '-',
            log['type'] ?? '-',
            log['quantite'].toString(),
            log['utilisateur']?['nom'] ?? '-',
            log['sac']?['nom'] ?? '-',
          ]),
    ];

    final csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.csv',
    );

    await file.writeAsString(csv);
    return file;
  }

  // ---------- Helpers ----------

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  String _safeDate(dynamic raw) {
    if (raw == null) return '-';
    return raw.toString().split('T').first;
  }
}
