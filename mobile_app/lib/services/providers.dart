import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction.dart';
import '../data/models/category.dart';
import 'database_service.dart';

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final transactionsProvider = FutureProvider<List<AppTransaction>>((ref) async {
  final dbService = ref.watch(databaseProvider);
  final db = await dbService.database;
  final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
  return List.generate(maps.length, (i) => AppTransaction.fromMap(maps[i]));
});

final balanceProvider = FutureProvider<double>((ref) async {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.when(
    data: (transactions) {
      double total = 0;
      for (var t in transactions) {
        if (t.type == 'income') {
          total += t.amount;
        } else {
          total -= t.amount;
        }
      }
      return total;
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

final categoriesProvider = FutureProvider<List<AppCategory>>((ref) async {
  final dbService = ref.watch(databaseProvider);
  final db = await dbService.database;
  final List<Map<String, dynamic>> maps = await db.query('categories');
  return List.generate(maps.length, (i) => AppCategory.fromMap(maps[i]));
});
