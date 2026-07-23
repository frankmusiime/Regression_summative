class PredictionRequest {
  final double qualityOfEducation;
  final double alumniEmployment;
  final double qualityOfFaculty;
  final double publications;
  final double influence;
  final double citations;
  final double broadImpact;
  final double patents;
  final int year;

  PredictionRequest({
    required this.qualityOfEducation,
    required this.alumniEmployment,
    required this.qualityOfFaculty,
    required this.publications,
    required this.influence,
    required this.citations,
    required this.broadImpact,
    required this.patents,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      "quality_of_education": qualityOfEducation,
      "alumni_employment": alumniEmployment,
      "quality_of_faculty": qualityOfFaculty,
      "publications": publications,
      "influence": influence,
      "citations": citations,
      "broad_impact": broadImpact,
      "patents": patents,
      "year": year,
    };
  }
}