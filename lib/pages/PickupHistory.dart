import 'package:flutter/material.dart';
import '../utils/csv_exporter.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class PickupHistoryWidget extends StatefulWidget {
  const PickupHistoryWidget({super.key});

  static String routeName = 'PickupHistory';

  @override
  State<PickupHistoryWidget> createState() => _PickupHistoryWidgetState();
}

class _PickupHistoryWidgetState extends State<PickupHistoryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SupabaseService _supabaseService = SupabaseService();

  String _searchQuery = '';
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _allHistoryItems = [];
  bool _isLoading = true;
  int _todayCount = 0;
  String _selectedStatus = 'Todos'; // 'Todos', 'Exitoso', 'Alerta'

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      if (profile != null) {
        print("📜 Cargando historial para el tutor: ${profile['id']}");
        final logs = await _supabaseService.getRecentPickupLogs(profile['id']);
        final todayCount = await _supabaseService.getTodayPickupsCount(profile['id']);
        
        print("📊 Registros encontrados: ${logs.length}");
        
        setState(() {
          _allHistoryItems = logs.map((log) {
            final student = log['estudiantes'];
            final thirdParty = log['terceros'];
            final guard = log['perfiles'];
            final DateTime date = DateTime.parse(log['fecha_hora']).toLocal();
            
            return {
              'studentName': student != null ? student['nombre'] : 'Desconocido',
              'grade': student != null ? student['curso'] : 'N/A', 
              'time': DateFormat('hh:mm a').format(date),
              'authorizedBy': thirdParty != null 
                  ? "${thirdParty['nombre']} (${thirdParty['relacion'] ?? 'Tercero'})" 
                  : 'Tutor Principal',
              'guardName': guard != null ? guard['nombre_completo'] : 'Sistema', 
              'isFlagged': log['estado'] == 'Alerta',
              'date': date,
            };
          }).toList();
          _todayCount = todayCount;
          _isLoading = false;
        });
      } else {
        print("❌ No se encontró el perfil para el historial.");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error loading history: $e");
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    return _allHistoryItems.where((item) {
      final matchesSearch =
          item['studentName'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['authorizedBy'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

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

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.deepPurple.shade900,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filtros', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                        _selectedStatus = 'Todos';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Limpiar Todo', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
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
                        setModalState(() => _selectedStatus = status);
                        setState(() => _selectedStatus = status);
                      },
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                title: Text(_selectedDate == null ? 'Cualquier fecha' : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await _pickDate();
                  setModalState(() {});
                },
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
                  child: const Text('Aplicar Filtros', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportReport() async {
    final filteredList = _filteredItems;
    if (filteredList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay datos para exportar.')),
      );
      return;
    }

    String csvContent =
        "Estudiante,Grado,Hora,Autorizado Por,Guardia,Estado,Fecha\n";
    for (var item in filteredList) {
      String student = '"${item['studentName']}"';
      String grade = '"${item['grade']}"';
      String time = '"${item['time']}"';
      String auth = '"${item['authorizedBy']}"';
      String guard = '"${item['guardName']}"';
      String status = item['isFlagged'] ? '"Alerta"' : '"Completado"';
      DateTime d = item['date'];
      String date = '"${d.day}/${d.month}/${d.year}"';

      csvContent += "$student,$grade,$time,$auth,$guard,$status,$date\n";
    }

    try {
      downloadCSV('reporte_diario.csv', csvContent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte descargado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo exportar el archivo.')),
      );
    }
  }

  Widget _buildSummaryCard(
    String value,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8)),
          ),
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
              'Detalles del Retiro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://dimg.dreamflow.cloud/v1/image/smiling%20school%20boy%20portrait',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Student',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
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
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://dimg.dreamflow.cloud/v1/image/professional%20woman%20portrait',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Authorized',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Info Grid
                    _buildModalRow(
                      Icons.person_rounded,
                      'Estudiante',
                      studentName,
                    ),
                    _buildModalRow(Icons.school_rounded, 'Curso', grade),
                    _buildModalRow(
                      Icons.access_time_filled_rounded,
                      'Hora',
                      time,
                    ),
                    _buildModalRow(
                      Icons.verified_user_rounded,
                      'Autorizado por',
                      authorizedBy,
                    ),
                    _buildModalRow(
                      Icons.security_rounded,
                      'Personal de Seguridad',
                      guardName,
                    ),

                    const SizedBox(height: 24),

                    // Security Badge
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isFlagged
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isFlagged
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isFlagged
                                ? Icons.warning_rounded
                                : Icons.verified_rounded,
                            color: isFlagged ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isFlagged
                                      ? 'Atención Requerida'
                                      : 'Verificación Segura',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isFlagged
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                Text(
                                  isFlagged
                                      ? 'Intervención manual del guardia'
                                      : 'Confianza de coincidencia: 98.4%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isFlagged
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                  ),
                                ),
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

  Widget _buildHistoryItem({
    required String studentName,
    required String grade,
    required String time,
    required String authorizedBy,
    required String guardName,
    required bool isFlagged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFlagged ? Colors.red.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                studentName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isFlagged ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFlagged ? "Alerta" : "Exitoso",
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
          Text(
            grade,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const Divider(height: 16),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text("Autoriza: $authorizedBy", style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.security, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text("Guardia: $guardName", style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;

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
                  const Text(
                    'Historial de Retiros',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // --- BOTÓN DE FILTRO SUPERIOR MEJORADO ---
                  Container(
                    decoration: BoxDecoration(
                      color: _selectedDate != null ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.tune_rounded,
                            color: _selectedDate != null ? Colors.deepPurple : Colors.grey.shade700,
                          ),
                          onPressed: _showFilterDialog,
                        ),
                        if (_selectedDate != null || _selectedStatus != 'Todos')
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
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
                        Expanded(
                          child: _buildSummaryCard(
                            _todayCount.toString(),
                            "Total Hoy",
                            Colors.deepPurple,
                            Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            "0", // Puedes conectar esto a otra lógica si hay pendientes
                            "Pendientes",
                            Colors.orange.shade100,
                            Colors.deepOrange.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Search & Date
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) => setState(() => _searchQuery = value),
                            decoration: InputDecoration(
                              hintText: "Buscar estudiante...",
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
                        // --- SELECTOR DE FECHA (PILL) MEJORADO ---
                        GestureDetector(
                          onTap: _pickDate,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedDate != null ? Colors.deepPurple : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedDate != null 
                                    ? Colors.deepPurple.withOpacity(0.3) 
                                    : Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                              border: Border.all(
                                color: _selectedDate != null ? Colors.deepPurple : Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _selectedDate != null ? Icons.event_available_rounded : Icons.calendar_month_rounded,
                                  color: _selectedDate != null ? Colors.white : Colors.deepPurple,
                                  size: 22,
                                ),
                                if (_selectedDate != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('dd/MM').format(_selectedDate!),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedDate = null);
                                    },
                                    child: const Icon(Icons.close_rounded, color: Colors.white70, size: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Lista de Historial
                    const Text(
                      'Actividad Reciente',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
                      )
                    else if (filteredList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: Text("No se encontraron registros.", style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ...filteredList.map((item) => GestureDetector(
                        onTap: () => _showDetailModal(
                          studentName: item['studentName'],
                          grade: item['grade'],
                          time: item['time'],
                          authorizedBy: item['authorizedBy'],
                          guardName: item['guardName'],
                          isFlagged: item['isFlagged'],
                        ),
                        child: _buildHistoryItem(
                          studentName: item['studentName'],
                          grade: item['grade'],
                          time: item['time'],
                          authorizedBy: item['authorizedBy'],
                          guardName: item['guardName'],
                          isFlagged: item['isFlagged'],
                        ),
                      )),

                    const SizedBox(height: 16),

                    // Export Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _exportReport,
                        icon: const Icon(
                          Icons.download_rounded,
                          color: Colors.deepPurple,
                        ),
                        label: const Text(
                          'Exportar Reporte Diario',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
