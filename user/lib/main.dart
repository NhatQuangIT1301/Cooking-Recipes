import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// provider removed: app runs without LanguageProvider for now
// import 'package:flutter_localizations/flutter_localizations.dart'; // THÊM MỚI

// THÊM MỚI: Import 2 file bạn đã tạo
import 'feature/home/introduce_screen.dart'; // Giả sử bạn lưu file này ở 'lib/providers/'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooking Recipes',
      theme: ThemeData(
        primarySwatch: Colors.green, // Dùng màu xanh chủ đạo
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      // Localization: (temporarily disabled to avoid gen-l10n build error)
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [Locale('en'), Locale('vi')],

      home: const OnboardingScreen(),
    );
  }
}