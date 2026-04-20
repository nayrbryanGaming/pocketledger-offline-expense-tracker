import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/providers.dart';
import '../../services/export_service.dart';
import '../../services/notification_service.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/backup_service.dart';
import '../categories/category_manager_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = AdaptiveTheme.of(context).mode.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFF10B981)),
            value: isDark,
            onChanged: (v) => AdaptiveTheme.of(context).toggleThemeMode(),
          ),
          const Divider(),
          _buildSectionHeader('Security & Privacy'),
          Consumer(
            builder: (context, ref, child) {
              final security = ref.watch(securityProvider);
              return FutureBuilder<bool>(
                future: security.isBiometricAvailable(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return SwitchListTile(
                      title: const Text('Biometric Lock'),
                      subtitle: const Text('Unlock with Fingerprint or FaceID.'),
                      secondary: const Icon(Icons.fingerprint, color: Color(0xFF10B981)),
                      value: ref.watch(biometricEnabledProvider),
                      onChanged: (v) async {
                        await SecurityService.toggleSecurity(v);
                        ref.read(biometricEnabledProvider.notifier).state = v;
                      },
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          ),
          ListTile(
            title: const Text('Language / Bahasa'),
            subtitle: Text(ref.watch(localeProvider).languageCode == 'en' ? 'English' : 'Bahasa Indonesia'),
            leading: const Icon(Icons.language, color: Color(0xFF10B981)),
            onTap: () => _showLanguagePicker(context, ref),
          ),
          ListTile(
            title: const Text('Default Currency'),
            subtitle: Text('Current: ${ref.watch(currencyProvider)}'),
            leading: const Icon(Icons.attach_money, color: Color(0xFF10B981)),
            onTap: () => _showCurrencyPicker(context, ref),
          ),
          ListTile(
            title: const Text('Manage Categories'),
            subtitle: const Text('Add, Edit categories & Set Monthly Budgets.'),
            leading: const Icon(Icons.category_outlined, color: Color(0xFF10B981)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryManagerScreen()),
            ),
          ),
          const Divider(),
          _buildSectionHeader('Notifications'),
          Consumer(
            builder: (context, ref, child) {
              return FutureBuilder<bool>(
                future: SharedPreferences.getInstance().then((p) => p.getBool('notifications_enabled') ?? true),
                builder: (context, snapshot) {
                  final isEnabled = snapshot.data ?? true;
                  return SwitchListTile(
                    title: const Text('Daily Reminders'),
                    subtitle: const Text('Get notified daily at 8:00 PM to log expenses.'),
                    secondary: const Icon(Icons.notifications_active, color: Color(0xFF10B981)),
                    value: isEnabled,
                    onChanged: (v) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('notifications_enabled', v);
                      if (v) {
                        await NotificationService().scheduleDailyReminder();
                      } else {
                        await NotificationService().cancelAllNotifications();
                      }
                      ref.read(transactionsProvider.notifier).refresh(); // Force rebuild to update switch UI temporarily
                    },
                  );
                },
              );
            },
          ),
          const Divider(),
          const Divider(),

          _buildSectionHeader('Data Management'),
          ListTile(
            title: const Text('Backup to JSON'),
            subtitle: const Text('Export a secure, encrypted-ready file of your entire history.'),
            leading: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF10B981)),
            onTap: () async {
              final path = await BackupService(ref.read(databaseProvider)).exportToJSON();
              if (path != null) {
                Share.shareXFiles([XFile(path)], text: 'PocketLedger Backup');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export failed.')));
              }
            },
          ),
          ListTile(
            title: const Text('Restore from JSON'),
            subtitle: const Text('Import data from a previous PocketLedger backup file.'),
            leading: const Icon(Icons.settings_backup_restore_rounded, color: Color(0xFF10B981)),
            onTap: () async {
              final success = await BackupService(ref.read(databaseProvider)).importFromJSON();
              if (success) {
                ref.read(transactionsProvider.notifier).refresh();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data restored successfully!')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore failed or cancelled.')));
              }
            },
          ),
          ListTile(
            title: const Text('Export to CSV'),
            subtitle: const Text('Generate a spreadsheet-ready file (Excel/Google Sheets).'),
            leading: const Icon(Icons.table_view_outlined, color: Color(0xFF10B981)),
            onTap: () {
              transactionsAsync.whenData((txs) {
                CSVExportService.exportTransactions(txs);
              });
            },
          ),
          ListTile(
            title: const Text('Flush All Data'),
            subtitle: const Text('This will permanently delete the local SQLite database.'),
            leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
            onTap: () => _showWipeConfirmation(context, ref),
          ),
          const Divider(),
          _buildSectionHeader('Support & Legal'),
          ListTile(
            title: const Text('PocketLedger Pro'),
            subtitle: const Text('Version 2.0.0-ULTIMATE'),
            leading: const Icon(Icons.auto_awesome_outlined, color: Color(0xFF10B981)),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our strict No-Cloud commitment.'),
            leading: const Icon(Icons.gavel_outlined, color: Color(0xFF10B981)),
            onTap: () {
              // Navigation or launcher for privacy_policy.md
            },
          ),
          ListTile(
            title: const Text('Rate on Play Store'),
            subtitle: const Text('Love the app? Leave 5 stars to support offline privacy!'),
            leading: const Icon(Icons.star_rate_rounded, color: Colors.amber),
            onTap: () async {
              final InAppReview inAppReview = InAppReview.instance;
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              }
            },
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Privacy is a human right. PocketLedger is offline-first.',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
      ),
    );
  }


// ... in build method or helpers
  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const BorderRadius.vertical(top: Radius.circular(24)),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _languageItem(context, ref, 'en', 'English'),
            _languageItem(context, ref, 'id', 'Bahasa Indonesia'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _languageItem(BuildContext context, WidgetRef ref, String code, String name) {
    final current = ref.watch(localeProvider).languageCode;
    return ListTile(
      title: Text(name),
      trailing: current == code ? const Icon(Icons.check, color: Color(0xFF10B981)) : null,
      onTap: () {
        ref.read(localeProvider.notifier).state = Locale(code);
        Navigator.pop(context);
      },
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const BorderRadius.vertical(top: Radius.circular(24)),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _currencyItem(context, ref, 'IDR', 'Indonesian Rupiah (Rp)'),
            _currencyItem(context, ref, 'USD', 'US Dollar (\$)'),
            _currencyItem(context, ref, 'EUR', 'Euro (€)'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _currencyItem(BuildContext context, WidgetRef ref, String code, String name) {
    final current = ref.watch(currencyProvider);
    return ListTile(
      title: Text(name),
      trailing: current == code ? const Icon(Icons.check, color: Color(0xFF10B981)) : null,
      onTap: () {
        ref.read(currencyProvider.notifier).state = code;
        Navigator.pop(context);
      },
    );
  }

  void _showWipeConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wipe All Data?'),
        content: const Text('This action is permanent and cannot be undone. All your offline records will be deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(databaseProvider).wipeAllData();
              ref.read(transactionsProvider.notifier).refresh();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data wiped successfully.')));
            }, 
            child: const Text('Wipe', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
