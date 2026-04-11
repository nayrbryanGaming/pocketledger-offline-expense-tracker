import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database; // init the db
  runApp(
    const ProviderScope(
      child: PocketLedgerApp(),
    ),
  );
}

class PocketLedgerApp extends StatelessWidget {
  const PocketLedgerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketLedger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF10B981),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          secondary: Color(0xFFFBBF24),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
