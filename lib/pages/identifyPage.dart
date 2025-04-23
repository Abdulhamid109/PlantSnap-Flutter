import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantsnap/pages/homepage.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:plantsnap/utils/PlantDetailsDialog.dart';

class IdentifyPage extends StatefulWidget {
  final File image;

  const IdentifyPage({super.key, required this.image});

  @override
  State<IdentifyPage> createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  String? responseText;
  bool isLoading = false;
  bool showMoreButton = false;
  String content = "";
  List<Map<String, dynamic>>? predictions;
  String? currentDocId;

  @override
  void initState() {
    super.initState();
    identify(widget.image);
  }

  Future<void> mistralQuery(String plantClass) async {
    setState(() {
      isLoading = true;
    });

    const apiKey = "6qqszHzcPAKvzMKk5v03pA4rnA7JcHjR";
    const model = "mistral-large-latest";

    final client = MistralAIClient(apiKey: apiKey);
    final query = "Provide detailed information about $plantClass, including its scientific name, "
        "vernacular names, advantages, disadvantages, uses, and other relevant details.";

    try {
      final chatResponse = await client.chatComplete(
        request: ChatCompletionRequest(
          model: model,
          messages: [{
            'role': 'user',
            'content': query,
          }],
        ),
      );
      
      content = chatResponse.choices?.first.message.content.toString() ?? 'No information available';
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> addPlantData(String title, String plantDetails) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (currentDocId != null) {
          // Update existing document with plant details
          await FirebaseFirestore.instance.collection("PlantData").doc(currentDocId).update({
            "title": title,
            "plantDetails": plantDetails,
          });
        }
      } else {
        throw 'User not authenticated';
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<void> handleLearnMore() async {
    if (responseText != null) {
      setState(() {
        isLoading = true;
      });

      // Check if plant data exists in database
      final existingData = await checkPlantInDatabase(responseText!);
      if (existingData != null) {
        // Use existing data from database
        setState(() {
          content = existingData['plantDetails'];
          isLoading = false;
        });
      } else {
        // Make Mistral API call if data doesn't exist
        await mistralQuery(responseText!);
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => PlantDetailsDialog(plantDetails: content),
        );
        addPlantData(responseText!, content);
      }
    }
  }

  Future<void> identify(File selectedImage) async {
    try {
      setState(() {
        isLoading = true;
        showMoreButton = false;
      });

      final url = Uri.parse('https://plant-api-abd-production.up.railway.app/predict/');
      final request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          selectedImage.path,
        ),
      );

      request.headers.addAll({
        'Accept': 'application/json',
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());
        print('Response: $jsonResponse'); // Debug print

        setState(() {
          responseText = jsonResponse['predicted_class'] ?? "No Data found";
          predictions = [
            {
              'class': jsonResponse['predicted_class'],
              'confidence': jsonResponse['confidence'] ?? 1.0,
            }
          ];
          isLoading = false;
          showMoreButton = true;
        });

        // Save to history
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            // Convert File path to downloadable URL
            String? imageUrl;
            if (selectedImage != null) {
              final bytes = await selectedImage.readAsBytes();
              final base64Image = base64Encode(bytes);
              imageUrl = 'data:image/jpeg;base64,$base64Image';
            }

            print('Saving to history...'); // Debug print
            final docRef = await FirebaseFirestore.instance.collection('PlantData').add({
              'Plant-uid': user.uid,
              'timestamp': FieldValue.serverTimestamp(),
              'imageUrl': imageUrl,
              'predictions': predictions,
              'title': responseText,
            });
            currentDocId = docRef.id;  // Store the document ID
            print('Saved to history successfully'); // Debug print
          }
        } catch (e) {
          print('Error saving to history: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving to history: $e')),
            );
          }
        }
      } else {
        final responseData = await http.Response.fromStream(response);
        setState(() {
          responseText = 'Error: ${responseData.body}';
        });
      }
    } catch (e) {
      setState(() {
        responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> checkPlantInDatabase(String plantName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection("PlantData")
            .where("title", isEqualTo: plantName)
            .where("Plant-uid", isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return {
            'title': querySnapshot.docs.first['title'],
            'plantDetails': querySnapshot.docs.first['plantDetails'],
          };
        }
      }
      return null;
    } catch (e) {
      print('Error checking plant in database: ${e.toString()}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.green),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage(login: 0)),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Plant Identification",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.image != null)
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  if (isLoading)
                    Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Analyzing your plant...",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (responseText != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Identification Result",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            responseText!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (showMoreButton)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : handleLearnMore,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  isLoading ? "Loading..." : "Learn More",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
