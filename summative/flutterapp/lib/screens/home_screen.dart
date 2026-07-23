import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/prediction_request.dart';
import '../models/prediction_response.dart';
import '../widgets/prediction_form.dart';
import '../widgets/prediction_result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();

  PredictionResponse? prediction;

  bool loading = false;

  // Academic Rankings
  double qualityEducation = 150;
  double alumniEmployment = 200;
  double qualityFaculty = 100;

  // Research Rankings
  double publications = 500;
  double influence = 500;
  double citations = 400;
  double broadImpact = 500;
  double patents = 400;

  int year = 2015;

  Future<void> predict() async {
    setState(() {
      loading = true;
    });

    try {
      final request = PredictionRequest(
        qualityOfEducation: qualityEducation,
        alumniEmployment: alumniEmployment,
        qualityOfFaculty: qualityFaculty,
        publications: publications,
        influence: influence,
        citations: citations,
        broadImpact: broadImpact,
        patents: patents,
        year: year,
      );

      final result = await api.predict(request);

      setState(() {
        prediction = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> retrainModel() async {
    try {
      final result = await api.retrain();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("University Performance Predictor"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            PredictionForm(

              qualityEducation: qualityEducation,
              alumniEmployment: alumniEmployment,
              qualityFaculty: qualityFaculty,

              publications: publications,
              influence: influence,
              citations: citations,
              broadImpact: broadImpact,
              patents: patents,

              year: year,

              onQualityEducationChanged: (value) {
                setState(() => qualityEducation = value);
              },

              onAlumniEmploymentChanged: (value) {
                setState(() => alumniEmployment = value);
              },

              onQualityFacultyChanged: (value) {
                setState(() => qualityFaculty = value);
              },

              onPublicationsChanged: (value) {
                setState(() => publications = value);
              },

              onInfluenceChanged: (value) {
                setState(() => influence = value);
              },

              onCitationsChanged: (value) {
                setState(() => citations = value);
              },

              onBroadImpactChanged: (value) {
                setState(() => broadImpact = value);
              },

              onPatentsChanged: (value) {
                setState(() => patents = value);
              },

              onYearChanged: (value) {
                setState(() => year = value!);
              },

              onPredict: predict,
            ),

            const SizedBox(height: 30),

            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (prediction != null)
              PredictionResult(
                model: prediction!.modelUsed,
                score: prediction!.predictedScore,
              ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: retrainModel,
              icon: const Icon(Icons.refresh),
              label: const Text("Retrain Best Model"),
            ),
          ],
        ),
      ),
    );
  }
}