// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'PocketLedger';

  @override
  String get dashboard => 'Beranda';

  @override
  String get settings => 'Pengaturan';

  @override
  String get addTransaction => 'Tambah Transaksi';

  @override
  String get income => 'Pemasukan';

  @override
  String get expense => 'Pengeluaran';

  @override
  String get monthlyBudget => 'Anggaran Bulanan';

  @override
  String get recentTransactions => 'Transaksi Terakhir';

  @override
  String get noTransactions => 'Belum ada transaksi. Ketuk + untuk mulai!';

  @override
  String get searchHint => 'Cari transaksi...';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get dataManagement => 'Manajemen Data';

  @override
  String get backupJson => 'Cadangkan ke JSON';

  @override
  String get restoreJson => 'Pulihkan dari JSON';

  @override
  String get flushData => 'Hapus Semua Data';

  @override
  String get manageCategories => 'Kelola Kategori';

  @override
  String get monthlyLimit => 'Batas Bulanan';

  @override
  String get spent => 'Terpakai';

  @override
  String get limit => 'Batas';

  @override
  String get exceeded => 'TERLAMPUI';
}
