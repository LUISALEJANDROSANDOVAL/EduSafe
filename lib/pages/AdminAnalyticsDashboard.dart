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

  bool _showAlert = true;
  String _selectedTimeFilter = 'Hoy';

  final Map<String, List<double>> _chartData = {
    'Hoy': [30, 60, 90, 140, 100, 50],
    'Semana': [200, 400, 350, 600, 500, 250],
    'Mes': [800, 1500, 1200, 2400, 2000, 900],
  };
  
  final Map<String, double> _chartMaxFlex = {
    'Hoy': 140,
    'Semana': 600,
    'Mes': 2400,
  };

  Widget _buildCriticalAlert() {
    if (!_showAlert) return const SizedBox.shrink();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anomalía Crítica Detectada', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                Text('3 validaciones manuales consecutivas en la Puerta B.', style: TextStyle(color: Colors.orange.shade800, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.orange.shade800),
            onPressed: () => setState(() => _showAlert = false),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String delta, bool trendUp) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: trendUp ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(trendUp ? Icons.arrow_upward : Icons.arrow_downward, 
                        color: trendUp ? Colors.green : Colors.red, size: 14),
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

  Widget _buildTimeFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: ['Hoy', 'Semana', 'Mes'].map((filter) {
        bool isSelected = _selectedTimeFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            onTap: () => setState(() => _selectedTimeFilter = filter),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.deepPurple,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBarChartSimulation() {
    List<double> currentData = _chartData[_selectedTimeFilter] ?? _chartData['Hoy']!;
    double maxFlex = _chartMaxFlex[_selectedTimeFilter] ?? _chartMaxFlex['Hoy']!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recojos por Hora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              _buildTimeFilters(),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarItem('8am', currentData[0], maxFlex),
                _buildBarItem('10am', currentData[1], maxFlex),
                _buildBarItem('12pm', currentData[2], maxFlex),
                _buildBarItem('2pm', currentData[3], maxFlex),
                _buildBarItem('4pm', currentData[4], maxFlex),
                _buildBarItem('6pm', currentData[5], maxFlex),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Actividad máxima detectada alrededor de las 2:00 PM',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(String label, double flexValue, double maxFlex) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                heightFactor: flexValue / maxFlex,
                child: Container(
                  width: 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade300, Colors.deepPurple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildVerificationHealth() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estado de Verificaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 24),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.94,
                      strokeWidth: 10,
                      backgroundColor: Colors.deepPurple.shade50,
                      color: Colors.deepPurple,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('94%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.deepPurple)),
                      Text('Precisión', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(Colors.deepPurple, '94% Coincidencia Biométrica'),
                    const SizedBox(height: 16),
                    _buildLegendItem(Colors.deepPurple.shade200, '6% Autorización Manual'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12, 
          height: 12, 
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))
        ),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildGuardPerformance() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rendimiento de Guardias Activos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          _buildGuardItem('Carlos Mendoza', 0.98),
          const SizedBox(height: 16),
          _buildGuardItem('Maria Garcia', 1.0),
        ],
      ),
    );
  }

  Widget _buildGuardItem(String name, double accuracy) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: const Icon(Icons.security, color: Colors.indigo, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('${(accuracy * 100).toInt()}% Precisión', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: accuracy,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade100,
                  color: accuracy >= 0.95 ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableAuditItem(String name, String status, String time, String authorizedBy, String gate) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.person, color: Colors.deepPurple),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('Estado: $status • $time', style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.account_circle, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Autorizado por: $authorizedBy', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Puerta: $gate', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: Colors.green.shade400, size: 28),
              ],
            ),
          ),
        ],
      ),
=======
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
>>>>>>> origin/feature
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(color: Colors.deepPurple.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Analíticas del Sistema', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        const SizedBox(height: 4),
                        Text('Administrador de EduSafe', style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.settings_rounded, color: Colors.deepPurple),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        tooltip: "Cerrar sesión",
                      ),
                    ),
                  ],
                ),
              ),
              
              _buildCriticalAlert(),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Métricas
                    Row(
                      children: [
                        Expanded(child: _buildMetricCard('Total Recojos', '1,284', '+12%', true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildMetricCard('Tutores Activos', '856', '+3%', true)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Gráfico
                    _buildBarChartSimulation(),
                    const SizedBox(height: 24),

                    // Salud del sistema
                    _buildVerificationHealth(),
                    const SizedBox(height: 24),

                    // Rendimiento de Guardias
                    _buildGuardPerformance(),
                    const SizedBox(height: 24),

                    // Gestión de Estudiantes y Guardias (botones)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminGuardManagementWidget()),
                              );
                            },
                            icon: const Icon(Icons.security, color: Colors.white, size: 18),
                            label: const Text('Personal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminStudentManagementWidget()),
                              );
                            },
                            icon: const Icon(Icons.school, color: Colors.white, size: 18),
                            label: const Text('Estudiantes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Audit Logs Expandibles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Registros Recientes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PickupHistoryWidget()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Ver Todo', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildExpandableAuditItem('Mateo Smith', 'Verificado', '2m ago', 'Carlos M.', 'Puerta Principal'),
                          Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
                          _buildExpandableAuditItem('Alana Velez', 'Verificado', '15m ago', 'Maria G.', 'Puerta Principal'),
                          Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
                          _buildExpandableAuditItem('Julian Ross', 'Excepción Manual', '42m ago', 'Carlos M.', 'Puerta B'),
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
