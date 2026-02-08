import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'services/api_service.dart';
import 'pages/auth/login_page.dart';
import 'pages/siswa/home_page.dart';
import 'pages/admin/admin_home_page.dart';

void main() {
  runApp(const KantinSekolahApp());
}

class KantinSekolahApp extends StatefulWidget {
  const KantinSekolahApp({super.key});

  @override
  State<KantinSekolahApp> createState() => _KantinSekolahAppState();
}

class _KantinSekolahAppState extends State<KantinSekolahApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Sekolah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryRed,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          primary: AppColors.primaryRed,
          secondary: AppColors.darkRed,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
          ),
        ),
      ),
      home: FutureBuilder<String?>(
        future: ApiService.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          if (snapshot.hasData && snapshot.data != null) {
            // Token exists, navigate to home (default to siswa home)
            // In a real app, you'd verify the token and get user role
            return const SiswaHomePage();
          }
          
          return const LoginPage();
        },
      ),
    );
  }
}
