import 'package:flutter/material.dart';
import 'pages/dew_point_screen.dart';

void main() => runApp(const DewPointCalculator());

class DewPointCalculator extends StatelessWidget {
  const DewPointCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dew Point Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DewPointScreen(),
    );
  }
}
