import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/csv_exporter.dart';

class PickupHistoryWidget extends StatefulWidget {
  const PickupHistoryWidget({super.key});

  static String routeName = 'PickupHistory';

  @override
  State<PickupHistoryWidget> createState() => _PickupHistoryWidgetState();
}

class _PickupHistoryWidgetState extends State<PickupHistoryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _searchQuery = '';
  DateTime? _selectedDate;
  String _selectedStatusFilter = 'Todos';

  bool _isLoading = true;
  List<Map<String, dynamic>> _allHistoryItems = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('registro_salidas')
          .select('*, estudiantes(nombre)')
          .order('fecha_hora', ascending: false);

      final guardiasResponse = await supabase.from('perfiles').select('id, nombre_completo').eq('rol', 'Encargado');
      Map<String, String> guardiasMap = {};
      for (var g in guardiasResponse) {
        guardiasMap[g['id'].toString()] = g['nombre_completo'].toString();
      }

      final tercerosResponse = await supabase.from('terceros').select('id, nombre');
      Map<String, String> tercerosMap = {};
      for (var t in tercerosResponse) {
        tercerosMap[t['id'].toString()] = t['nombre'].toString();
      }

      final tutoresResponse = await supabase.from('perfiles').select('id, nombre_completo').eq('rol', 'Tutor');
      Map<String, String> tutoresMap = {};
      for (var t in tutoresResponse) {
        tutoresMap[t['id'].toString()] = t['nombre_completo'].toString();
      }

      List<Map<String, dynamic>> loadedData = [];
      for (var row in response) {
        String studentName = 'Desconocido';
        if (row['estudiantes'] != null && row['estudiantes'] is Map) {
          studentName = row['estudiantes']['nombre'] ?? 'Desconocido';
        } else if (row['estudiantes'] != null && row['estudiantes'] is List && row['estudiantes'].isNotEmpty) {
          studentName = row['estudiantes'][0]['nombre'] ?? 'Desconocido';
        }

        String authorizedBy = 'Desconocido';
        if (row['tercero_id'] != null) {
          authorizedBy = tercerosMap[row['tercero_id'].toString()] ?? 'Tercero Desconocido';
        } else if (row['tutor_autorizador_id'] != null) {
          authorizedBy = tutoresMap[row['tutor_autorizador_id'].toString()] ?? 'Tutor Principal';
        }

        String guardName = 'Desconocido';
        if (row['encargado_id'] != null) {
          guardName = guardiasMap[row['encargado_id'].toString()] ?? 'Guardia Desconocido';
        }

        bool isFlagged = row['estado'] == 'Alerta' || row['estado'] == 'Rechazado';

        DateTime date = DateTime.now();
        String time = '--:--';
        if (row['fecha_hora'] != null) {
          date = DateTime.parse(row['fecha_hora']).toLocal();
          int hour = date.hour;
          int min = date.minute;
          String ampm = hour >= 12 ? 'PM' : 'AM';
          hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
          time = '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $ampm';
        }

        loadedData.add({
          'studentName': studentName,
          'grade': 'N/D',
          'time': time,
          'authorizedBy': authorizedBy,
          'guardName': guardName,
          'isFlagged': isFlagged,
          'date': date,
          'estado': row['estado'] ?? 'Completado',
        });
      }

      if (mounted) {
        setState(() {
          _allHistoryItems = loadedData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
      if (_selectedStatusFilter == 'Completado') {
        matchesStatus = item['isFlagged'] == false;
      } else if (_selectedStatusFilter == 'Alerta') {
        matchesStatus = item['isFlagged'] == true;
      }

      return matchesSearch && matchesDate && matchesStatus;
    }).toList();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros Avanzados',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Estado del Registro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Todos', 'Completado', 'Alerta'].map((status) {
                      final isSelected = _selectedStatusFilter == status;
                      return ChoiceChip(
                        label: Text(status),
                        selected: isSelected,
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => _selectedStatusFilter = status);
                            setState(() => _selectedStatusFilter = status);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Aplicar Filtros', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
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
                                'Estudiante',
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
                                'Autorizado',
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
                    _buildModalRow(Icons.school_rounded, 'Grado', grade),
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
                      'Guardia de Seguridad',
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
                                      ? 'Registro manual por guardia'
                                      : 'Confianza Biométrica: 98.4%',
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
      child: InkWell(
        onTap: () {
          _showDetailModal(
            studentName: studentName,
            grade: grade,
            time: time,
            authorizedBy: authorizedBy,
            guardName: guardName,
            isFlagged: isFlagged,
          );
        },
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
                    isFlagged ? "Alerta" : "Completado",
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
                Text("Aut: $authorizedBy", style: const TextStyle(fontSize: 12)),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;

    int totalHoy = 0;
    int alertasHoy = 0;
    final hoy = DateTime.now();
    for (var item in _allHistoryItems) {
      if (item['date'].year == hoy.year &&
          item['date'].month == hoy.month &&
          item['date'].day == hoy.day) {
        totalHoy++;
        if (item['isFlagged']) alertasHoy++;
      }
    }

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
                  IconButton(
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: Colors.deepPurple,
                    ),
                    onPressed: _showFilterModal,
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            "$totalHoy",
                            "Total Hoy",
                            Colors.deepPurple,
                            Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            "$alertasHoy",
                            "Alertas Hoy",
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
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            decoration: InputDecoration(
                              hintText: "Buscar estudiante...",
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _selectedDate != null
                                  ? Colors.deepPurple
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedDate != null
                                    ? Colors.deepPurple
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: _selectedDate != null
                                      ? Colors.white
                                      : Colors.deepPurple,
                                ),
                                if (_selectedDate != null) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedDate = null);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // History List
                    const Text(
                      'Actividad Reciente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (filteredList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: Text(
                            "No se encontraron registros.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...filteredList.map((item) => _buildHistoryItem(
                        studentName: item['studentName'],
                        grade: item['grade'],
                        time: item['time'],
                        authorizedBy: item['authorizedBy'],
                        guardName: item['guardName'],
                        isFlagged: item['isFlagged'],
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
