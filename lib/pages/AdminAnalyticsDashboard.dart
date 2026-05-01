import 'package:flutter/material.dart';
import 'PickupHistory.dart';
import 'AdminGuardManagement.dart';
import 'AdminStudentManagement.dart';

class AdminAnalyticsDashboardWidget extends StatefulWidget {
  const AdminAnalyticsDashboardWidget({super.key});

  static String routeName = 'AdminAnalyticsDashboard';

  @override
  State<AdminAnalyticsDashboardWidget> createState() => _AdminAnalyticsDashboardWidgetState();
}

class _AdminAnalyticsDashboardWidgetState extends State<AdminAnalyticsDashboardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildMetricCard(String label, String value, String delta, bool trendUp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trendUp ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(trendUp ? Icons.arrow_upward : Icons.arrow_downward, 
                        color: trendUp ? Colors.green : Colors.red, size: 12),
                    const SizedBox(width: 4),
                    Text(delta, style: TextStyle(color: trendUp ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartSimulation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pickups per Hour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Icon(Icons.bar_chart_rounded, color: Colors.deepPurple.shade300),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarItem('8am', 30),
                _buildBarItem('10am', 60),
                _buildBarItem('12pm', 90),
                _buildBarItem('2pm', 140),
                _buildBarItem('4pm', 100),
                _buildBarItem('6pm', 50),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Peak activity detected at 2:00 PM dismissal',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(String label, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVerificationHealth() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Verification Health', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular progress indicator simulado
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: 0.94,
                      strokeWidth: 8,
                      backgroundColor: Colors.deepPurple.shade100,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const Text('94%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Text('94% Biometric Match', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.deepPurple.shade100, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Text('6% Manual Override', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAuditDetail(String name, String status, String time) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text('Audit Log Detail', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),
                    
                    _buildModalRow(Icons.access_time_filled_rounded, 'Time Ago', time),
                    _buildModalRow(Icons.calendar_today_rounded, 'Date', 'May 01, 2026'),
                    _buildModalRow(Icons.security_rounded, 'Verified by Staff', 'Guard Rodriguez'),
                    _buildModalRow(Icons.location_on_rounded, 'Gate', 'Main Entrance (North)'),
                    
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.deepPurple),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This record has been digitally signed and stored in the secure audit trail.',
                              style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildAuditItem(String name, String status, String time) {
    return ListTile(
      onTap: () => _showAuditDetail(name, status, time),
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text('Status: $status', style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('System Analytics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('Safe School Administrator', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_rounded, color: Colors.grey),
                      onPressed: () {
                        // Navegar a settings o logout
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      tooltip: "Cerrar sesión (Temporal)",
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Métricas
                    Row(
                      children: [
                        Expanded(child: _buildMetricCard('Total Pickups', '1,284', '+12%', true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildMetricCard('Active Tutors', '856', '+3%', true)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Gráfico
                    _buildBarChartSimulation(),
                    const SizedBox(height: 24),

                    // Salud del sistema
                    _buildVerificationHealth(),
                    const SizedBox(height: 24),

                    // Gestión de Guardias
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminGuardManagementWidget()),
                          );
                        },
                        icon: const Icon(Icons.security, color: Colors.white),
                        label: const Text('Manage Security Staff', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gestión de Estudiantes y Padres
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminStudentManagementWidget()),
                          );
                        },
                        icon: const Icon(Icons.school, color: Colors.white),
                        label: const Text('Manage Students & Tutors', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Audit Logs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Audit Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PickupHistoryWidget()),
                            );
                          },
                          child: const Text('View All', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildAuditItem('Mateo Smith', 'Verified', '2m ago'),
                          const Divider(height: 1),
                          _buildAuditItem('Alana Velez', 'Verified', '15m ago'),
                          const Divider(height: 1),
                          _buildAuditItem('Julian Ross', 'Verified', '42m ago'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
