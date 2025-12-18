import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_website/pages/portfolio_home_page.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abir Cherif | Flutter Mobile Developer',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue.shade800,
        scaffoldBackgroundColor: Colors.grey.shade50,
        textTheme: GoogleFonts.poppinsTextTheme()
            .apply(bodyColor: Colors.grey.shade900),
        cardTheme: CardThemeData(
          elevation: 6,
          shadowColor: Colors.blue.withOpacity(0.15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            elevation: 4,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue.shade600,
        scaffoldBackgroundColor: Colors.grey.shade900,
        textTheme:
            GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
        cardTheme: CardThemeData(
          elevation: 6,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            elevation: 4,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const PortfolioHomePage(),
    );
  }
}
