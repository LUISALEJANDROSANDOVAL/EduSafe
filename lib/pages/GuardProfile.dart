import 'package:flutter/material.dart';

class GuardProfileWidget extends StatelessWidget {
  const GuardProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Security Guard Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.security, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Carlos Rodriguez', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Senior Security Officer', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                  const Divider(height: 32),
                  _buildInfoRow(Icons.badge_rounded, 'Employee ID', 'SEC-8942-A'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.email_rounded, 'Work Email', 'crodriguez@safeguard.edu'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.phone_rounded, 'Emergency Contact', '+1 555-0198'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.access_time_filled_rounded, 'Shift Schedule', 'Morning (06:00 AM - 02:00 PM)'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Security Clearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                  const Divider(height: 32),
                  _buildInfoRow(Icons.verified_user_rounded, 'Clearance Level', 'Level 3 (Main Gates & Primary Pickups)'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.shield_rounded, 'Active Certifications', 'CPR, First Aid, Crisis Mgmt'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
