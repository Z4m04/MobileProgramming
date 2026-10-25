import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(const BandographyApp());

class BandographyApp extends StatelessWidget {
  const BandographyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bandography',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff9b8cff),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xff15131c),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff15131c),
        surfaceTintColor: Colors.transparent,
      ),
    ),
    home: const HomePage(),
  );
}
