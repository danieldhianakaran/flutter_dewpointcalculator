import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'calculation_details_page.dart';

class DewPointScreen extends StatefulWidget {
  const DewPointScreen({super.key});

  @override
  State<DewPointScreen> createState() => _DewPointScreenState();
}

class _DewPointScreenState extends State<DewPointScreen> {
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _rhController = TextEditingController();
  String _resultText = '';
  double? _dewPoint;
  Color _cardColor = Colors.grey.shade200;
  Color _appBarColor = Colors.white;
  bool _showResult = false;

  void _calculateDewPoint() {
    setState(() {
      _showResult = false;
      _cardColor = Colors.grey.shade200;
      _appBarColor = Colors.white;
    });

    try {
      final temp = double.parse(_tempController.text);
      final rh = double.parse(_rhController.text);

      if (rh < 0 || rh > 100) {
        throw Exception('Relative humidity must be between 0 and 100');
      }

      final dewPoint = _calculate(temp, rh);
      final tempDiff = temp - dewPoint;

      Color color;
      String message;

      if (tempDiff > 4.5) {
        color = Colors.green;
        message = 'Air conditioning is GOOD.';
      } else if (tempDiff >= 3) {
        color = Colors.amber;
        message = 'Air conditioning is moderate.';
      } else {
        color = Colors.red;
        message = 'Warning: High risk of condensation.';
      }

      setState(() {
        _dewPoint = dewPoint;
        _resultText = message;
        _cardColor = color;
        _appBarColor = color;
        _showResult = true;
      });

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  double _calculate(double temp, double rh) {
    if (rh == 0) return double.negativeInfinity;

    final rhFraction = rh / 100.0;
    final alpha = log(rhFraction) + (17.625 * temp) / (243.04 + temp);
    return (243.04 * alpha) / (17.625 - alpha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: const Text(
          'Dew Point Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalculationDetailsPage(
                    temp: double.tryParse(_tempController.text),
                    rh: double.tryParse(_rhController.text),
                    dewPoint: _dewPoint,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Temperature (°C)',
                  prefixIcon: Icon(Icons.whatshot),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _rhController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Relative Humidity (%)',
                  prefixIcon: Icon(Icons.water_drop),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.deepOrange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _calculateDewPoint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_showResult)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Dew Point: ${(_dewPoint!.isNegative && _dewPoint!.isInfinite) ? 'N/A' : _dewPoint!.toStringAsFixed(2)}°C',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Temperature Difference: ${(_dewPoint!.isNegative && _dewPoint!.isInfinite) ? 'N/A' : (double.parse(_tempController.text) - _dewPoint!).toStringAsFixed(2)}°C',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _resultText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                'Developed by MRTians',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
