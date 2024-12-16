import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup/home_cards/map.dart';
import 'dart:developer' as devtools;

import 'home_cards/excercise.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  File? filePath;
  String label = '';
  double confidence = 0.0;

  Future<void> _validateAndRunPrimaryModel(String imagePath) async {
    // Load the validation model
    await Tflite.loadModel(
      model: "assets/valid.tflite",
      labels: "assets/valid.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );

    // Run validation on the image
    var validationResults = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.5,
      asynch: true,
    );

    if (validationResults == null || validationResults.isEmpty) {
      devtools.log("Validation failed: No recognition results");
      setState(() {
        label = "Invalid Image";
        confidence = 0.0;
      });
      await Tflite.close();
      return;
    }

    if(validationResults[0]['label'] == '1'){
      // Load primary model
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );

      // Run primary model on the image
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );

      if (recognitions == null || recognitions.isEmpty) {
        devtools.log("Recognition is Null");
        await Tflite.close();
        return;
      }

      devtools.log(recognitions.toString());
      setState(() {
        confidence = (recognitions[0]['confidence'] * 100);
        label = recognitions[0]['label'].toString();
      });

      await Tflite.close(); // Close primary model
    } else {
      setState(() {
        label = 'Invalid Image';
        confidence = (validationResults[0]['confidence'] * 100);
      });
    }
  }

  Future<void> _processImage(XFile image) async {
    setState(() {
      filePath = File(image.path);
    });

    // Validate and run primary model if validation passes
    await _validateAndRunPrimaryModel(image.path);
  }

  Future<void> pickImageGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) await _processImage(image);
  }

  // Future<void> pickImageCamera() async {
  //   final picker = ImagePicker();
  //   final image = await picker.pickImage(source: ImageSource.camera);
  //   if (image != null) await _processImage(image);
  // }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white, size: 35),
        title: Text("Knee Osteoarthritis Detection",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        height: 280,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/upload.png'),
                          ),
                        ),
                        child: filePath == null
                            ? const Text('')
                            : Image.file(filePath!, fit: BoxFit.fill),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Confidence: ${confidence.toStringAsFixed(0)}%",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 65),
              if (label == 'healthy')
                Text(
                  "Take care of yourself",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              else if (label == 'moderate')
                InkWell(
                  onTap: () {
                    // Navigate to Exercise Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExerciseScreen()),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('Go to Exercise', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: .15)],
                    ),
                  ),
                )
              else if (label == 'unhealthy')
                InkWell(
                  onTap: () {
                    // Navigate to Maps Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoogleMapPage()),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('Go to Maps', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: .15)],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              // InkWell(
              //   onTap: pickImageCamera,
              //   child: Container(
              //     width: 200,
              //     height: 50,
              //     child: Center(child: Text('Take using camera', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              //     decoration: BoxDecoration(
              //         color: Colors.blue,
              //         borderRadius: BorderRadius.circular(11),
              //         boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: .15)]),
              //   ),
              // ),
              const SizedBox(height: 8),
              InkWell(
                onTap: pickImageGallery,
                child: Container(
                  width: 200,
                  height: 50,
                  child: Center(child: Text('Pick from Gallery', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: .15)]),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
