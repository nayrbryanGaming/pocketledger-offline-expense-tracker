import '../data/models/transaction.dart';
import 'database_service.dart';

class RecurringEngine {
  final DatabaseService _db;

  RecurringEngine(this._db);

  Future<void> sync() async {
    final recurringTxs = await _db.getRecurringTransactions();
    final now = DateTime.now();

    for (var tx in recurringTxs) {
      final lastDate = tx.lastGeneratedDate ?? tx.date;
      final frequency = tx.frequency ?? 'monthly';
      
      DateTime nextDue;
      switch (frequency) {
        case 'daily':
          nextDue = lastDate.add(const Duration(days: 1));
          break;
        case 'weekly':
          nextDue = lastDate.add(const Duration(days: 7));
          break;
        case 'monthly':
        default:
          nextDue = DateTime(lastDate.year, lastDate.month + 1, lastDate.day);
          break;
      }

      // Generate all missing instances up to today
      DateTime tempDate = nextDue;
      while (tempDate.isBefore(now) || isSameDay(tempDate, now)) {
        final newInstance = tx.copyWith(
          id: null, // New entry
          date: tempDate,
          isRecurring: false, // Instances are just static records
          frequency: null,
          lastGeneratedDate: null,
        );
        
        await _db.insertTransaction(newInstance);
        
        // Update the master recurring record's last generated date
        final updatedMaster = tx.copyWith(lastGeneratedDate: tempDate);
        await _db.updateTransaction(updatedMaster);
        
        // Move to next cycle
        if (frequency == 'daily') {
          tempDate = tempDate.add(const Duration(days: 1));
        } else if (frequency == 'weekly') {
          tempDate = tempDate.add(const Duration(days: 7));
        } else {
          tempDate = DateTime(tempDate.year, tempDate.month + 1, tempDate.day);
        }
      }
    }
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
