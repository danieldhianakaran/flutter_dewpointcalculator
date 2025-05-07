import 'package:flutter/material.dart';

class CalculationDetailsPage extends StatelessWidget {
  final double? temp;
  final double? rh;
  final double? dewPoint;

  const CalculationDetailsPage({
    super.key,
    this.temp,
    this.rh,
    this.dewPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dew Point Calculation Formula',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The dew point temperature is calculated using the Magnus-Tetens formula:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            // Replace with actual image asset or formula widget
            Image.asset('assets/formula.png'), // You need to add this image
            const SizedBox(height: 24),
            if (temp != null && rh != null && dewPoint != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step-by-Step Calculation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '1. Relative Humidity Fraction (rhFraction) = $rh / 100 = ${(rh! / 100).toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2. Alpha (α) = ln(${(rh! / 100).toStringAsFixed(4)}) + (17.625 * $temp) / (243.04 + $temp)',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '   = ${(log(rh! / 100) + (17.625 * temp!) / (243.04 + temp!)).toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3. Dew Point Temperature = (243.04 * α) / (17.625 - α)',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '   = ${(243.04 * (log(rh! / 100) + (17.625 * temp!) / (243.04 + temp!))) / (17.625 - (log(rh! / 100) + (17.625 * temp!) / (243.04 + temp!)))}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '   = ${dewPoint!.toStringAsFixed(2)}°C',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
