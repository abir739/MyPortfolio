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
      title: 'Abir Cherif Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.grey.shade100,
        cardTheme: CardThemeData(
          elevation: 6,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            elevation: 3,
          ),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}



