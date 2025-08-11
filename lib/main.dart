import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/price_range_screen.dart';
import 'screens/request_status_screen.dart';
import 'screens/store_selection_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/language_settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Shoofly',
          debugShowCheckedModeBanner: false,
          locale: languageProvider.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF2196F3),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2196F3),
              secondary: const Color(0xFFFF9800),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2196F3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
              floatingLabelStyle: const TextStyle(color: Color(0xFF2196F3)),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              elevation: 0,
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            useMaterial3: true,
          ),
          initialRoute: '/home',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/reset-password': (context) => const ResetPasswordScreen(),
            '/home': (context) => const HomeScreen(),
            '/camera': (context) => const CameraScreen(),
            '/price-range': (context) => const PriceRangeScreen(),
            '/request-status': (context) => const RequestStatusScreen(),
            '/store-selection': (context) => const StoreSelectionScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/language-settings': (context) => const LanguageSettingsScreen(),
          },
        );
      },
    );
  }
}
