import 'package:flutter/material.dart';

class SecurityCenterPage extends StatelessWidget {
  const SecurityCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Security Center', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shield_rounded, size: 60, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text('Your Security is our Priority', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('At EduSafe, we use military-grade encryption and biometric verification to ensure your child safety.', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            _buildSecurityItem(
              Icons.lock_outline, 
              'Data Encryption', 
              'All personal and biometric data is hashed and encrypted before being stored.'
            ),
            _buildSecurityItem(
              Icons.visibility_off_outlined, 
              'Privacy Policy', 
              'We never share your personal information with third parties without your consent.'
            ),
            _buildSecurityItem(
              Icons.verified_user_outlined, 
              'Biometric Verification', 
              'Face matching is performed locally or via secure hashes to protect identity.'
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Read Full Privacy Policy', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Terms of Service', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
