import 'package:flutter/material.dart';

class PredictionForm extends StatelessWidget {
  const PredictionForm({
    super.key,

    required this.qualityEducation,
    required this.alumniEmployment,
    required this.qualityFaculty,

    required this.publications,
    required this.influence,
    required this.citations,
    required this.broadImpact,
    required this.patents,

    required this.year,

    required this.onQualityEducationChanged,
    required this.onAlumniEmploymentChanged,
    required this.onQualityFacultyChanged,

    required this.onPublicationsChanged,
    required this.onInfluenceChanged,
    required this.onCitationsChanged,
    required this.onBroadImpactChanged,
    required this.onPatentsChanged,

    required this.onYearChanged,

    required this.onPredict,
  });

  final double qualityEducation;
  final double alumniEmployment;
  final double qualityFaculty;

  final double publications;
  final double influence;
  final double citations;
  final double broadImpact;
  final double patents;

  final int year;

  final ValueChanged<double> onQualityEducationChanged;
  final ValueChanged<double> onAlumniEmploymentChanged;
  final ValueChanged<double> onQualityFacultyChanged;

  final ValueChanged<double> onPublicationsChanged;
  final ValueChanged<double> onInfluenceChanged;
  final ValueChanged<double> onCitationsChanged;
  final ValueChanged<double> onBroadImpactChanged;
  final ValueChanged<double> onPatentsChanged;

  final ValueChanged<int?> onYearChanged;

  final VoidCallback onPredict;

  Widget buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              value.round().toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),

          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value.round().toString(),
            onChanged: onChanged,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.round().toString()),
              Text(max.round().toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard(
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        buildCard(
          "Academic Rankings",
          [

            buildSlider(
              title: "Quality of Education",
              value: qualityEducation,
              min: 1,
              max: 367,
              onChanged: onQualityEducationChanged,
            ),

            buildSlider(
              title: "Alumni Employment",
              value: alumniEmployment,
              min: 1,
              max: 567,
              onChanged: onAlumniEmploymentChanged,
            ),

            buildSlider(
              title: "Quality of Faculty",
              value: qualityFaculty,
              min: 1,
              max: 218,
              onChanged: onQualityFacultyChanged,
            ),
          ],
        ),

        buildCard(
          "Research Rankings",
          [

            buildSlider(
              title: "Publications",
              value: publications,
              min: 1,
              max: 1000,
              onChanged: onPublicationsChanged,
            ),

            buildSlider(
              title: "Influence",
              value: influence,
              min: 1,
              max: 991,
              onChanged: onInfluenceChanged,
            ),

            buildSlider(
              title: "Citations",
              value: citations,
              min: 1,
              max: 812,
              onChanged: onCitationsChanged,
            ),

            buildSlider(
              title: "Broad Impact",
              value: broadImpact,
              min: 1,
              max: 1000,
              onChanged: onBroadImpactChanged,
            ),

            buildSlider(
              title: "Patents",
              value: patents,
              min: 1,
              max: 871,
              onChanged: onPatentsChanged,
            ),
          ],
        ),

        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Dataset Year",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<int>(
                  value: year,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 2012,
                      child: Text("2012"),
                    ),
                    DropdownMenuItem(
                      value: 2013,
                      child: Text("2013"),
                    ),
                    DropdownMenuItem(
                      value: 2014,
                      child: Text("2014"),
                    ),
                    DropdownMenuItem(
                      value: 2015,
                      child: Text("2015"),
                    ),
                  ],
                  onChanged: onYearChanged,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.analytics),
            label: const Text(
              "Predict University Score",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: onPredict,
          ),
        ),
      ],
    );
  }
}