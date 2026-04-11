import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction.dart';
import '../data/models/category.dart';
import 'database_service.dart';

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

class TransactionsNotifier extends StateNotifier<AsyncValue<List<AppTransaction>>> {
  final DatabaseService _db;
  TransactionsNotifier(this._db) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final transactions = await _db.getTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(AppTransaction transaction) async {
    try {
      await _db.insertTransaction(transaction);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _db.deleteTransaction(id);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, AsyncValue<List<AppTransaction>>>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionsNotifier(db);
});

final categoriesProvider = FutureProvider<List<AppCategory>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getCategories();
});

final balanceProvider = Provider<double>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.maybeWhen(
    data: (transactions) {
      return transactions.fold(0.0, (sum, t) {
        return t.type == 'income' ? sum + t.amount : sum - t.amount;
      });
    },
    orElse: () => 0.0,
  );
});

final monthlySpendingProvider = Provider<Map<String, double>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.maybeWhen(
    data: (transactions) {
      final Map<String, double> spending = {};
      final now = DateTime.now();
      final monthTransactions = transactions.where((t) => t.date.month == now.month && t.date.year == now.year && t.type == 'expense');
      
      for (var t in monthTransactions) {
        final day = t.date.day.toString();
        spending[day] = (spending[day] ?? 0) + t.amount;
      }
      return spending;
    },
    orElse: () => {},
  );
});
