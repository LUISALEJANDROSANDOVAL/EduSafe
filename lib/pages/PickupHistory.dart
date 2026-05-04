import 'package:flutter/material.dart';
import '../utils/csv_exporter.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class PickupHistoryWidget extends StatefulWidget {
  const PickupHistoryWidget({super.key});

  @override
  State<PickupHistoryWidget> createState() => _PickupHistoryWidgetState();
}

class _PickupHistoryWidgetState extends State<PickupHistoryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _supabaseService = SupabaseService();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  DateTime? _selectedDate;
  String _selectedStatus = 'Todos'; 
  List<Map<String, dynamic>> _allHistoryItems = [];
  bool _isLoading = true;
  int _todayCount = 0;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistoryData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      if (profile != null) {
        final role = profile['rol'];
        // Si es administrador o encargado, vemos todo. Si es Tutor, solo lo suyo.
        final String? filterId = (role == 'Administrador' || role == 'Encargado') ? null : profile['id'];
        
        final logs = await _supabaseService.getRecentPickupLogs(filterId);
        final todayLogsCount = await _supabaseService.getTodayPickupsCount(filterId);
        
        List<Map<String, dynamic>> items = [];
        for (var log in logs) {
          final student = log['estudiantes'];
          final thirdParty = log['terceros'];
          final guard = log['guardia']; // Usando el alias definido en el servicio
          
          DateTime date = DateTime.now();
          String time = '--:--';
          if (log['fecha_hora'] != null) {
            try {
              date = DateTime.parse(log['fecha_hora']).toLocal();
              time = DateFormat('hh:mm a').format(date);
            } catch (e) {
              debugPrint("Error parsing date: ${log['fecha_hora']}");
            }
          }

          // Truncar UUID para mostrar si no hay nombre
          String formatId(dynamic id) {
            if (id == null) return 'N/A';
            String s = id.toString();
            return s.length > 8 ? s.substring(0, 8) : s;
          }

          items.add({
            'studentName': student != null ? student['nombre'] : "Estudiante (${formatId(log['estudiante_id'])})",
            'grade': student != null ? student['curso'] : 'N/A',
            'time': time,
            'authorizedBy': thirdParty != null 
                ? "${thirdParty['nombre']} (${thirdParty['relacion'] ?? 'Tercero'})" 
                : (log['tercero_id'] != null ? 'Tercero Registrado' : 'Tutor Principal'),
            'guardName': guard != null ? guard['nombre_completo'] : "Guardia (${formatId(log['encargado_id'])})", 
            'isFlagged': log['estado'] == 'Alerta' || log['estado'] == 'Rechazado',
            'status': log['estado'] ?? 'Exitoso',
            'date': date,
          });
        }

        if (mounted) {
          setState(() {
            _allHistoryItems = items;
            _todayCount = todayLogsCount;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("🚨 Error loading history: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    return _allHistoryItems.where((item) {
      final matchesSearch =
          item['studentName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['authorizedBy'].toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesDate = true;
      if (_selectedDate != null) {
        DateTime itemDate = item['date'];
        matchesDate =
            itemDate.year == _selectedDate!.year &&
            itemDate.month == _selectedDate!.month &&
            itemDate.day == _selectedDate!.day;
      }

      bool matchesStatus = true;
      if (_selectedStatus != 'Todos') {
        matchesStatus = (item['isFlagged'] ? 'Alerta' : 'Exitoso') == _selectedStatus;
      }

      return matchesSearch && matchesDate && matchesStatus;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filtros Avanzados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Estado del Retiro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: ['Todos', 'Exitoso', 'Alerta'].map((status) {
                bool isSel = _selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSel,
                    onSelected: (val) {
                      setState(() => _selectedStatus = status);
                      Navigator.pop(context);
                      _showFilterModal();
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Aplicar Filtros', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportReport() async {
    final filteredList = _filteredItems;
    if (filteredList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay datos para exportar')));
      return;
    }
    await CsvExporter.exportHistory(filteredList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reporte exportado correctamente')));
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

   Widget _buildHistoryCard(Map<String, dynamic> item) {
    bool isFlagged = item['isFlagged'] ?? false;
    String statusText = item['status'] ?? (isFlagged ? "Alerta" : "Exitoso");
    Color statusColor = statusText == 'Exitoso' ? Colors.green : (statusText == 'Rechazado' ? Colors.red : Colors.orange);
    Color statusBg = statusColor.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusBg,
                  child: Icon(
                    statusText == 'Exitoso' ? Icons.check_circle_outline : (statusText == 'Rechazado' ? Icons.cancel_outlined : Icons.warning_rounded), 
                    color: statusColor
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['studentName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Grado: ${item['grade']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.access_time_rounded, item['time']),
                _buildInfoItem(Icons.person_outline, item['authorizedBy']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem(Icons.security, 'Guardia: ${item['guardName']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Flexible(child: Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 11), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Historial de Salidas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune_rounded, color: Colors.white),
                        onPressed: _showFilterModal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Hoy',
                          '$_todayCount',
                          const Color(0xFF673AB7),
                          Icons.today_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Alertas',
                          '${_allHistoryItems.where((i) => i['isFlagged']).length}',
                          const Color(0xFFFF9800),
                          Icons.warning_amber_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar estudiante...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: _selectedDate != null ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Actividad Reciente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadHistoryData,
                      child: _filteredItems.isEmpty 
                          ? ListView(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No hay registros',
                                      style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: _loadHistoryData,
                                      child: const Text('Reintentar'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                return _buildHistoryCard(_filteredItems[index]);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportReport,
        backgroundColor: Colors.green,
        child: const Icon(Icons.download_rounded, color: Colors.white),
      ),
    );
  }
}
