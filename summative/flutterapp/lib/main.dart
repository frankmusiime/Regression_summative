import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const LinearRegressionApp());
}

class LinearRegressionApp extends StatelessWidget {
  const LinearRegressionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Score Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}