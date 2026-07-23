class RetrainResponse {
  final String message;
  final String bestModel;
  final Map<String, dynamic> metrics;
  final List<dynamic> allModels;

  RetrainResponse({
    required this.message,
    required this.bestModel,
    required this.metrics,
    required this.allModels,
  });

  factory RetrainResponse.fromJson(Map<String, dynamic> json) {
    return RetrainResponse(
      message: json["message"],
      bestModel: json["best_model"],
      metrics: json["metrics"],
      allModels: json["all_models"],
    );
  }
}