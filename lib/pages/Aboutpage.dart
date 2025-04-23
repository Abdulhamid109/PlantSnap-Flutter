import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About PlantSnap'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.local_florist,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to PlantSnap!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'PlantSnap is your intelligent plant identification companion. Using advanced image recognition technology, we help you identify plants, flowers, and trees instantly with just a photo.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Instant Plant Recognition'),
            _buildFeatureItem('Detailed Plant Information'),
            _buildFeatureItem('User-Friendly Interface'),
            _buildFeatureItem('Offline Capability'),
            const SizedBox(height: 24),
            const Text(
              'How to Use:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Take or select a photo of any plant\n'
              '2. Let our AI analyze the image\n'
              '3. Get detailed information about the plant',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}