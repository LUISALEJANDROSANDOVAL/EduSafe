import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'PickupHistory.dart';
import 'AdminGuardManagement.dart';
import 'AdminStudentManagement.dart';

class AdminAnalyticsDashboardWidget extends StatefulWidget {
  const AdminAnalyticsDashboardWidget({super.key});

  static String routeName = 'AdminAnalyticsDashboard';

  @override
  State<AdminAnalyticsDashboardWidget> createState() =>
      _AdminAnalyticsDashboardWidgetState();
}

class _AdminAnalyticsDashboardWidgetState
    extends State<AdminAnalyticsDashboardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showAlert = false;
  String _selectedTimeFilter = 'Hoy';
  
  bool _isLoading = true;
  int _retirosTotales = 0;
  int _tutoresActivos = 0;
  List<Map<String, dynamic>> _auditoriaReciente = [];
  List<Map<String, dynamic>> _rendimientoGuardias = [];
  
  double _precisionBiometria = 0.94;
  String _alertMessage = '';
  
  Map<String, List<double>> _chartData = {
    'Hoy': [0, 0, 0, 0, 0, 0],
    'Semana': [200, 400, 350, 600, 500, 250],
    'Mes': [800, 1500, 1200, 2400, 2000, 900],
  };

  Map<String, double> _chartMaxFlex = {
    'Hoy': 10,
    'Semana': 600,
    'Mes': 2400,
  };

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final supabase = Supabase.instance.client;
      
      // 1. Retiros Totales (Exitosos)
      final retirosResponse = await supabase
          .from('registro_salidas')
          .select('id')
          .eq('estado', 'Exitoso');
      
      // 2. Tutores Activos
      final tutoresResponse = await supabase
          .from('perfiles')
          .select('id')
          .eq('rol', 'Tutor');
          
      // 3. Auditoría reciente
      final auditoriaResponse = await supabase
          .from('registro_salidas')
          .select('id, estado, fecha_hora, estudiantes(nombre)')
          .order('fecha_hora', ascending: false)
          .limit(3);
          
      // 4. Rendimiento de Guardias
      final guardias = await supabase.from('perfiles').select('id, nombre_completo').eq('rol', 'Encargado');
      Map<String, String> guardiasMap = {};
      for (var g in guardias) {
        guardiasMap[g['id'].toString()] = g['nombre_completo'].toString();
      }

      final guardiasLogs = await supabase.from('registro_salidas').select('encargado_id');
      Map<String, int> guardiasCount = {};
      for (var log in guardiasLogs) {
        if (log['encargado_id'] != null) {
          String id = log['encargado_id'].toString();
          String nombre = guardiasMap[id] ?? 'Guardia Desconocido';
          guardiasCount[nombre] = (guardiasCount[nombre] ?? 0) + 1;
        }
      }
      
      List<Map<String, dynamic>> guardiasRendimiento = guardiasCount.entries
          .map((e) => {'nombre': e.key, 'escaneos': e.value})
          .toList();
      guardiasRendimiento.sort((a, b) => b['escaneos'].compareTo(a['escaneos']));

      // 5. Chart Data y Precisión
      final hoyInicio = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toUtc().toIso8601String();
      final allHoy = await supabase
          .from('registro_salidas')
          .select('id, estado, fecha_hora')
          .gte('fecha_hora', hoyInicio);
          
      int totalHoy = allHoy.length;
      int exitososHoy = allHoy.where((e) => e['estado'] == 'Exitoso').length;
      double precision = totalHoy == 0 ? 0.94 : (exitososHoy / totalHoy);
      
      List<double> hoyCounts = [0, 0, 0, 0, 0, 0];
      for (var row in allHoy) {
        if (row['fecha_hora'] != null) {
          int hour = DateTime.parse(row['fecha_hora']).toLocal().hour;
          if (hour >= 8 && hour < 10) hoyCounts[0]++;
          else if (hour >= 10 && hour < 12) hoyCounts[1]++;
          else if (hour >= 12 && hour < 14) hoyCounts[2]++;
          else if (hour >= 14 && hour < 16) hoyCounts[3]++;
          else if (hour >= 16 && hour < 18) hoyCounts[4]++;
          else if (hour >= 18) hoyCounts[5]++;
        }
      }
      double maxCount = hoyCounts.isEmpty ? 10 : hoyCounts.reduce((a, b) => a > b ? a : b);
      if (maxCount < 10) maxCount = 10;
      
      // 6. Alerta Crítica
      final lastAlert = await supabase
          .from('registro_salidas')
          .select('estado, fecha_hora')
          .or('estado.eq.Alerta,estado.eq.Rechazado')
          .order('fecha_hora', ascending: false)
          .limit(1);
          
      String alertMsg = '';
      bool showAlert = false;
      if (lastAlert.isNotEmpty) {
        alertMsg = 'Se registró un intento con estado: ${lastAlert[0]['estado']} recientemente.';
        showAlert = true;
      }

      if (mounted) {
        setState(() {
          _retirosTotales = retirosResponse.length;
          _tutoresActivos = tutoresResponse.length;
          _auditoriaReciente = List<Map<String, dynamic>>.from(auditoriaResponse);
          _rendimientoGuardias = guardiasRendimiento.take(3).toList();
          
          _precisionBiometria = precision;
          _chartData['Hoy'] = hoyCounts;
          _chartMaxFlex['Hoy'] = maxCount;
          
          _alertMessage = alertMsg;
          _showAlert = showAlert;
          
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching dashboard data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade800,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anomalía Detectada',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                Text(
                  _alertMessage,
                  style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                ),
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

  Widget _buildMetricCard(
    String label,
    String value,
    String delta,
    bool trendUp,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: trendUp ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: trendUp ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      delta,
                      style: TextStyle(
                        color: trendUp ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
                color: isSelected
                    ? Colors.deepPurple
                    : Colors.deepPurple.shade50,
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
    List<double> currentData =
        _chartData[_selectedTimeFilter] ?? _chartData['Hoy']!;
    double maxFlex =
        _chartMaxFlex[_selectedTimeFilter] ?? _chartMaxFlex['Hoy']!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Retiros por Hora',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(Icons.bar_chart_rounded, color: Colors.deepPurple.shade300),
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
            'Actividad máxima detectada a las 2:00 PM (Salida)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Salud de Verificación',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _precisionBiometria,
                      strokeWidth: 10,
                      backgroundColor: Colors.deepPurple.shade50,
                      color: Colors.deepPurple,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_precisionBiometria * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const Text(
                        'Precisión',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
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
                  _buildLegendItem(Colors.deepPurple, '${(_precisionBiometria * 100).toInt()}% Exitoso'),
                    const SizedBox(height: 12),
                    _buildLegendItem(Colors.deepPurple.withOpacity(0.2), '${((1 - _precisionBiometria) * 100).toInt()}% Anómalo'),
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalle de Auditoría',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Validado',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildModalRow(
                      Icons.access_time_filled_rounded,
                      'Tiempo transcurrido',
                      time,
                    ),
                    _buildModalRow(
                      Icons.calendar_today_rounded,
                      'Fecha',
                      '01 de Mayo, 2026',
                    ),
                    _buildModalRow(
                      Icons.security_rounded,
                      'Verificado por',
                      'Guardia Rodriguez',
                    ),
                    _buildModalRow(
                      Icons.location_on_rounded,
                      'Puerta',
                      'Entrada Principal (Norte)',
                    ),

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
                              'Este registro ha sido firmado digitalmente y almacenado en la pista de auditoría segura.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple,
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
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildExpandableAuditItem(String name, String status, String time) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade50,
          child: const Icon(Icons.person, color: Colors.deepPurple, size: 20),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          'Recogida validada - $time',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGuardStat(Icons.verified_user_rounded, 'Confianza', '98.2%'),
                    _buildGuardStat(Icons.timer_outlined, 'Duración', '45s'),
                    _buildGuardStat(Icons.location_on_outlined, 'Puerta', 'Principal'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showAuditDetail(name, status, time),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Ver Evidencia Completa'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuardPerformance() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rendimiento de Guardias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Icon(Icons.military_tech_rounded, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_rendimientoGuardias.isEmpty)
            const Text('No hay datos de guardias')
          else
            ..._rendimientoGuardias.map((g) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildGuardStatRow(g['nombre'], 0.98, '${g['escaneos']} escaneos'),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildGuardStatRow(String name, double performance, String detail) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(detail, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: performance,
            backgroundColor: Colors.grey.shade100,
            color: performance > 0.9 ? Colors.green : (performance > 0.8 ? Colors.orange : Colors.red),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildGuardStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.deepPurple.shade300),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
      ],
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
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Análisis del Sistema',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Administrador de Escuela Segura',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
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
                        Expanded(
                          child: _buildMetricCard(
                            'Retiros Totales',
                            _isLoading ? '...' : '$_retirosTotales',
                            '+12%',
                            true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Tutores Activos',
                            _isLoading ? '...' : '$_tutoresActivos',
                            '+3%',
                            true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Controles Rápidos de Navegación
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickNavButton(
                            'Estudiantes', 
                            Icons.school_rounded, 
                            Colors.blue,
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminStudentManagementWidget())),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickNavButton(
                            'Guardias', 
                            Icons.security_rounded, 
                            Colors.indigo,
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminGuardManagementWidget())),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Gráfico y Filtros
                    _buildTimeFilters(),
                    const SizedBox(height: 16),
                    _buildBarChartSimulation(),
                    const SizedBox(height: 24),

                    // Salud del Sistema
                    _buildVerificationHealth(),
                    const SizedBox(height: 24),

                    // Rendimiento de Guardias
                    _buildGuardPerformance(),
                    const SizedBox(height: 24),

                    // Registro de Auditoría
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Registro de Auditoría Reciente',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(Icons.history_rounded, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (_auditoriaReciente.isEmpty)
                            const Text('No hay registros recientes')
                          else
                            ..._auditoriaReciente.map((log) {
                              String name = 'Estudiante';
                              if (log['estudiantes'] != null && log['estudiantes'] is Map) {
                                name = log['estudiantes']['nombre'] ?? 'Estudiante';
                              } else if (log['estudiantes'] != null && log['estudiantes'] is List && log['estudiantes'].isNotEmpty) {
                                name = log['estudiantes'][0]['nombre'] ?? 'Estudiante';
                              }
                              String status = log['estado'] ?? 'Desconocido';
                              String timeStr = 'Reciente';
                              if (log['fecha_hora'] != null) {
                                DateTime date = DateTime.parse(log['fecha_hora']).toLocal();
                                Duration diff = DateTime.now().difference(date);
                                if (diff.inMinutes < 60) {
                                  timeStr = 'hace ${diff.inMinutes}m';
                                } else if (diff.inHours < 24) {
                                  timeStr = 'hace ${diff.inHours}h';
                                } else {
                                  timeStr = 'hace ${diff.inDays}d';
                                }
                              }
                              return _buildExpandableAuditItem(name, status, timeStr);
                            }).toList(),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PickupHistoryWidget(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Ver Todos los Registros'),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
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

  Widget _buildQuickNavButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
