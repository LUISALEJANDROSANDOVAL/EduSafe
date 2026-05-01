import 'package:flutter/material.dart';

class PickupHistoryWidget extends StatefulWidget {
  const PickupHistoryWidget({super.key});

  static String routeName = 'PickupHistory';

  @override
  State<PickupHistoryWidget> createState() => _PickupHistoryWidgetState();
}

class _PickupHistoryWidgetState extends State<PickupHistoryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildSummaryCard(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
          Text(label, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8))),
        ],
      ),
    );
  }

  void _showDetailModal({
    required String studentName,
    required String grade,
    required String time,
    required String authorizedBy,
    required String guardName,
    required bool isFlagged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text('Pickup Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Photos Comparison
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  image: const DecorationImage(image: NetworkImage('https://dimg.dreamflow.cloud/v1/image/smiling%20school%20boy%20portrait'), fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('Student', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  image: const DecorationImage(image: NetworkImage('https://dimg.dreamflow.cloud/v1/image/professional%20woman%20portrait'), fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('Authorized', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Info Grid
                    _buildModalRow(Icons.person_rounded, 'Student', studentName),
                    _buildModalRow(Icons.school_rounded, 'Grade', grade),
                    _buildModalRow(Icons.access_time_filled_rounded, 'Time', time),
                    _buildModalRow(Icons.verified_user_rounded, 'Authorized by', authorizedBy),
                    _buildModalRow(Icons.security_rounded, 'Security Staff', guardName),
                    
                    const SizedBox(height: 24),
                    
                    // Security Badge
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isFlagged ? Colors.red.shade50 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isFlagged ? Colors.red.shade100 : Colors.green.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(isFlagged ? Icons.warning_rounded : Icons.verified_rounded, color: isFlagged ? Colors.red : Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isFlagged ? 'Attention Required' : 'Secure Verification', style: TextStyle(fontWeight: FontWeight.bold, color: isFlagged ? Colors.red : Colors.green)),
                                Text(isFlagged ? 'Manual override by guard' : 'Face Match Confidence: 98.4%', style: TextStyle(fontSize: 12, color: isFlagged ? Colors.red.shade700 : Colors.green.shade700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String studentName,
    required String grade,
    required String time,
    required String authorizedBy,
    required String guardName,
    required bool isFlagged,
  }) {
    return GestureDetector(
      onTap: () => _showDetailModal(
        studentName: studentName,
        grade: grade,
        time: time,
        authorizedBy: authorizedBy,
        guardName: guardName,
        isFlagged: isFlagged,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isFlagged ? Colors.red.shade200 : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFlagged ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isFlagged ? "Flagged" : "Completed",
                    style: TextStyle(
                      color: isFlagged ? Colors.red : Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(grade, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Auth: $authorizedBy", style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.security, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Guard: $guardName", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text('Pickup History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.deepPurple),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(child: _buildSummaryCard("128", "Total Today", Colors.deepPurple, Colors.white)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSummaryCard("12", "Pending", Colors.orange.shade100, Colors.deepOrange.shade900)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search & Date
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search student...",
                              prefixIcon: const Icon(Icons.search_rounded, size: 20),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Icon(Icons.calendar_month_rounded, color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // History List
                    const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildHistoryItem(
                      studentName: 'Mateo Garcia',
                      grade: '2nd Grade - A',
                      time: '02:45 PM',
                      authorizedBy: 'Lucia Garcia (Mother)',
                      guardName: 'Rodriguez',
                      isFlagged: false,
                    ),
                    _buildHistoryItem(
                      studentName: 'Sofia Chen',
                      grade: '1st Grade - B',
                      time: '02:40 PM',
                      authorizedBy: 'David Chen (Father)',
                      guardName: 'Rodriguez',
                      isFlagged: false,
                    ),
                    _buildHistoryItem(
                      studentName: 'Lucas Miller',
                      grade: 'K-5',
                      time: '02:32 PM',
                      authorizedBy: 'Unknown / No ID',
                      guardName: 'Rodriguez',
                      isFlagged: true, // Flagged for attention
                    ),
                    _buildHistoryItem(
                      studentName: 'Elena Rossi',
                      grade: '4th Grade - C',
                      time: '02:15 PM',
                      authorizedBy: 'Marco Rossi (Uncle)',
                      guardName: 'Martinez',
                      isFlagged: false,
                    ),
                    const SizedBox(height: 16),

                    // Export Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded, color: Colors.deepPurple),
                        label: const Text('Export Daily Report', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
