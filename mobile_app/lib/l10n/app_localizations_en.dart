// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PocketLedger';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get settings => 'Settings';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get monthlyBudget => 'Monthly Budgets';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactions => 'No transactions found. Tap + to start!';

  @override
  String get searchHint => 'Search transactions...';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get backupJson => 'Backup to JSON';

  @override
  String get restoreJson => 'Restore from JSON';

  @override
  String get flushData => 'Flush All Data';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get monthlyLimit => 'Monthly Limit';

  @override
  String get spent => 'Spent';

  @override
  String get limit => 'Limit';

  @override
  String get exceeded => 'EXCEEDED';
}
