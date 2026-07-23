import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/prediction_request.dart';
import '../models/prediction_response.dart';
import '../models/retrain_response.dart';

class ApiService {

  // Render Deployment
  static const String baseUrl =
      "https://regression-summative5.onrender.com";

  Future<PredictionResponse> predict(
      PredictionRequest request) async {

    final response = await http.post(
      Uri.parse("$baseUrl/predict"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PredictionResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Prediction failed.\n${response.body}",
    );
  }

  Future<RetrainResponse> retrain() async {

    final response = await http.post(
      Uri.parse("$baseUrl/retrain"),
    );

    if (response.statusCode == 200) {
      return RetrainResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      "Retraining failed.\n${response.body}",
    );
  }

  Future<bool> health() async {

    final response = await http.get(
      Uri.parse("$baseUrl/health"),
    );

    return response.statusCode == 200;
  }
}