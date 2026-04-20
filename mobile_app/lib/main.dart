import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'services/providers.dart';
import 'widgets/main_shell.dart';
import 'services/security_service.dart';
import 'services/notification_service.dart';
import 'services/database_service.dart';
import 'services/recurring_engine.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;
  final securityEnabled = prefs.getBool('biometric_enabled') ?? false;

  final db = DatabaseService();
  await RecurringEngine(db).sync();

  await NotificationService().init();
  if (onboardingDone) {
    if (prefs.getBool('notifications_enabled') ?? true) {
      await NotificationService().scheduleDailyReminder();
    }
  }

  bool isAuthenticated = !securityEnabled;
  // Note: We don't authenticate in main anymore to prevent slow startup
  // Authentication is handled by AuthLockScreen

  runApp(
    ProviderScope(
      overrides: [
        biometricEnabledProvider.overrideWith((ref) => securityEnabled),
      ],
      child: PocketLedgerApp(
        savedThemeMode: savedThemeMode,
        showOnboarding: !onboardingDone,
        startAuthenticated: isAuthenticated,
      ),
    ),
  );
}

class PocketLedgerApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final bool showOnboarding;
  final bool startAuthenticated;
  
  const PocketLedgerApp({
    Key? key, 
    this.savedThemeMode,
    required this.showOnboarding,
    required this.startAuthenticated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF10B981),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF10B981),
          secondary: Color(0xFFFBBF24),
          surface: Colors.white,
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF10B981),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          secondary: Color(0xFFFBBF24),
          surface: Color(0xFF1E293B),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'PocketLedger',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('id'),
        ],
        home: _getHome(),
      ),
    );
  }

  Widget _getHome() {
    if (!startAuthenticated) {
      return const AuthLockScreen();
    }
    return showOnboarding ? const OnboardingScreen() : const MainShell();
  }
}

class AuthLockScreen extends ConsumerWidget {
  const AuthLockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Color(0xFF10B981)),
            const SizedBox(height: 24),
            const Text('App Locked', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                final success = await ref.read(securityProvider).authenticate();
                if (success) {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (c) => const MainShell())
                  );
                }
              },
              child: const Text('Unlock with Biometrics'),
            ),
          ],
        ),
      ),
    );
  }
}
