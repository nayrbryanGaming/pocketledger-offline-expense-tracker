import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers.dart';
import '../../services/export_service.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

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
          _buildSectionHeader('Data Safety & Privacy'),
          ListTile(
            title: const Text('Local Storage Only'),
            subtitle: const Text('Your data is stored in an encrypted database on this device. No information is transmitted to any cloud servers.'),
            leading: const Icon(Icons.lock_person_outlined, color: Color(0xFF10B981)),
          ),
          ListTile(
            title: const Text('User Autonomy'),
            subtitle: const Text('You have 100% control. We cannot access, see, or delete your data remotely.'),
            leading: const Icon(Icons.verified_user_outlined, color: Color(0xFF10B981)),
          ),
          const Divider(),
          _buildSectionHeader('Data Management'),
          ListTile(
            title: const Text('Export JSON / CSV'),
            subtitle: const Text('Generate a secure portable file of your entire financial history.'),
            leading: const Icon(Icons.ios_share_outlined, color: Color(0xFF10B981)),
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
