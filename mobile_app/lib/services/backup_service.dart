import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'database_service.dart';
import '../data/models/transaction.dart';
import '../data/models/category.dart';

class BackupService {
  final DatabaseService _db;

  BackupService(this._db);

  Future<String?> exportToJSON() async {
    try {
      final transactions = await _db.getTransactions();
      final categories = await _db.getCategories();

      final data = {
        'version': 2,
        'export_date': DateTime.now().toIso8601String(),
        'transactions': transactions.map((t) => t.toMap()).toList(),
        'categories': categories.map((c) => c.toMap()).toList(),
      };

      final jsonString = jsonEncode(data);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pocketledger_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      
      await file.writeAsString(jsonString);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<bool> importFromJSON() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) return false;

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content);

      if (data['transactions'] == null) return false;

      // Wipe current data first (Selective or Full?)
      // Full wipe is safer for consistency
      await _db.wipeAllData();

      final txs = data['transactions'] as List;
      final cats = data['categories'] as List;

      // Note: We need to handle category IDs carefully if the user has custom categories
      // For now, we assume simplicity: wipe and reload all exactly as in the export.
      
      // We don't need to re-init DB here because wipeAllData sets _database to null,
      // and the next 'database' getter call will re-init.
      
      for (var catMap in cats) {
        // Categories table in SQLITE will auto-increment, 
        // but we might want to preserve IDs for FOREIGN KEY consistency.
        final db = await _db.database;
        await db.insert('categories', catMap);
      }

      for (var txMap in txs) {
        final db = await _db.database;
        await db.insert('transactions', txMap);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
