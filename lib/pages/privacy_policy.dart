import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Information We Collect',
              'We collect information that you provide directly to us, including:\n'
              '• Your name and email address when you create an account\n'
              '• Profile information such as your bio\n'
              '• Plant images you upload for identification\n'
              '• Your search and identification history',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n'
              '• Provide and improve our plant identification service\n'
              '• Personalize your experience\n'
              '• Send you important notifications\n'
              '• Maintain and improve app security',
            ),
            _buildSection(
              'Data Storage',
              'Your data is stored securely in our database. We implement appropriate '
              'security measures to protect your personal information.',
            ),
            _buildSection(
              'Third-Party Services',
              'We use Google Sign-In for authentication. Please review Google\'s '
              'privacy policy for more information about their data practices.',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n'
              '• Access your personal data\n'
              '• Update or correct your information\n'
              '• Delete your account and associated data\n'
              '• Opt-out of notifications',
            ),
            _buildSection(
              'Updates to Policy',
              'We may update this privacy policy from time to time. We will notify '
              'you of any changes by posting the new policy on this page.',
            ),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
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
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
