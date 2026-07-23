class PredictionResponse {
  final String modelUsed;
  final double predictedScore;

  PredictionResponse({
    required this.modelUsed,
    required this.predictedScore,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      modelUsed: json["model_used"],
      predictedScore: (json["predicted_score"] as num).toDouble(),
    );
  }
}