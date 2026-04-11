import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/models/transaction.dart';

class CSVExportService {
  static Future<void> exportTransactions(List<AppTransaction> transactions) async {
    List<List<dynamic>> rows = [];

    // Header
    rows.add(["ID", "Title", "Amount", "Type", "Category ID", "Date", "Note"]);

    for (var t in transactions) {
      List<dynamic> row = [];
      row.add(t.id);
      row.add(t.title);
      row.add(t.amount);
      row.add(t.type);
      row.add(t.categoryId);
      row.add(t.date.toIso8601String());
      row.add(t.note);
      rows.add(row);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/pocketledger_export_${DateTime.now().millisecondsSinceEpoch}.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: 'PocketLedger Transaction Export');
  }
}
