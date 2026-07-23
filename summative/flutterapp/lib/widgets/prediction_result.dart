import 'package:flutter/material.dart';

class PredictionResult extends StatelessWidget {
  final String model;
  final double score;

  const PredictionResult({
    super.key,
    required this.model,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Prediction Result",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Predicted Score",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(
              score.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 40,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Model Used",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(
              model,
              style: const TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}