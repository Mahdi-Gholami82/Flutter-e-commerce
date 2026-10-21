import 'package:digi_meh/home/presentation/page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DigiMehApp());
}

class DigiMehApp extends StatelessWidget {
  const DigiMehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DigiMeh",
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
