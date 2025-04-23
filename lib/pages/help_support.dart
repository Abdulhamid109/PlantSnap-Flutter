import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@plantsnap.com',
      query: 'subject=PlantSnap Support',
    );
    
    try {
      if (!await launchUrl(emailLaunchUri)) {
        throw 'Could not launch email';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open email app. Please email us at support@plantsnap.com'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green.shade400,
                Colors.green.shade800,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHelpSection(
              title: 'Frequently Asked Questions',
              items: [
                _buildExpandableFAQ(
                  'How does plant identification work?',
                  'Our app uses advanced AI technology to identify plants from photos. '
                  'Simply take a clear photo of the plant you want to identify, and '
                  'our system will analyze it and provide the most likely matches.',
                ),
                _buildExpandableFAQ(
                  'What makes a good plant photo?',
                  '• Good lighting - natural daylight is best\n'
                  '• Clear, focused image\n'
                  '• Include the whole plant or specific parts like leaves/flowers\n'
                  '• Avoid blurry or dark photos\n'
                  '• Multiple angles can help with accuracy',
                ),
                _buildExpandableFAQ(
                  'How accurate is the identification?',
                  'Our plant identification system is highly accurate but not perfect. '
                  'The accuracy depends on the quality of the photo and the uniqueness '
                  'of the plant. We provide multiple possible matches to help you make '
                  'the final determination.',
                ),
                _buildExpandableFAQ(
                  'Can I use the app offline?',
                  'Internet connection is required for plant identification as it uses '
                  'our cloud-based AI system. However, you can view your previously '
                  'identified plants in your history while offline.',
                ),
              ],
            ),
            _buildContactSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildExpandableFAQ(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: Colors.green),
                  title: const Text('Email Support'),
                  subtitle: const Text('Get help from our support team'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _launchEmail(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.chat_outlined, color: Colors.green),
                  title: const Text('Live Chat'),
                  subtitle: const Text('Chat with our support team'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Live chat coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
