import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/models/transaction.dart';
import '../data/models/category.dart';
import 'database_service.dart';
import '../services/security_service.dart';

final securityProvider = Provider((ref) => SecurityService());

final biometricEnabledProvider = StateProvider<bool>((ref) => false);

final currencyProvider = StateProvider<String>((ref) => 'IDR');

final privacyModeProvider = StateProvider<bool>((ref) => false);

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

class TransactionsNotifier extends StateNotifier<AsyncValue<List<AppTransaction>>> {
  final DatabaseService _db;
  String _searchQuery = '';
  String? _filterType; // 'income' or 'expense'
  int? _filterCategoryId;

  String? get filterType => _filterType;
  int? get filterCategoryId => _filterCategoryId;

  TransactionsNotifier(this._db) : super(const AsyncValue.loading()) {
    refresh();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    refresh();
  }

  void setFilterType(String? type) {
    _filterType = type;
    refresh();
  }

  void setFilterCategory(int? categoryId) {
    _filterCategoryId = categoryId;
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      var transactions = await _db.getTransactions();
      
      if (_searchQuery.isNotEmpty) {
        transactions = transactions.where((t) => 
          t.title.toLowerCase().contains(_searchQuery) || 
          t.note.toLowerCase().contains(_searchQuery)
        ).toList();
      }

      if (_filterType != null) {
        transactions = transactions.where((t) => t.type == _filterType).toList();
      }

      if (_filterCategoryId != null) {
        transactions = transactions.where((t) => t.categoryId == _filterCategoryId).toList();
      }

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
  return ref.watch(databaseProvider).getCategories();
});

final budgetsProvider = FutureProvider<List<AppBudget>>((ref) async {
  return ref.watch(databaseProvider).getBudgets();
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

final smartInsightsProvider = Provider<String?>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.maybeWhen(
    data: (transactions) {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1);
      
      final thisMonthSpending = transactions
          .where((t) => t.type == 'expense' && t.date.month == now.month && t.date.year == now.year)
          .fold(0.0, (sum, t) => sum + t.amount);
          
      final lastMonthSpending = transactions
          .where((t) => t.type == 'expense' && t.date.month == lastMonth.month && t.date.year == lastMonth.year)
          .fold(0.0, (sum, t) => sum + t.amount);
      
      if (thisMonthSpending == 0) return "Start logging to see insights! 📈";
      
      if (lastMonthSpending > 0) {
        final diff = ((thisMonthSpending - lastMonthSpending) / lastMonthSpending) * 100;
        if (diff < 0) {
          return "Great job! You spent ${diff.abs().toStringAsFixed(0)}% less than last month. 🚀";
        } else if (diff > 20) {
          return "Alert: Your spending is ${diff.toStringAsFixed(0)}% higher than last month. ⚠️";
        }
      }
      
      return "You're doing great! Keep tracking to master your budget.";
    },
    orElse: () => null,
  );
});
