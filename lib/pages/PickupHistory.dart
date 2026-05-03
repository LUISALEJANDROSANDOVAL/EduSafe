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
  String _selectedStatus = 'Todos'; // 'Todos', 'Exitoso', 'Alerta'
  List<Map<String, dynamic>> _allHistoryItems = [];
  bool _isLoading = true;
  int _todayCount = 0;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      if (profile != null) {
        final logs = await _supabaseService.getRecentPickupLogs(profile['id']);
        final todayLogsCount = await _supabaseService.getTodayPickupsCount(profile['id']);
        
        List<Map<String, dynamic>> items = [];
        for (var log in logs) {
          final student = log['estudiantes'];
          final thirdParty = log['terceros'];
          final guard = log['perfiles'];
          
          DateTime date = DateTime.now();
          String time = '--:--';
          if (log['fecha_hora'] != null) {
            date = DateTime.parse(log['fecha_hora']).toLocal();
            time = DateFormat('hh:mm a').format(date);
          }

          items.add({
            'studentName': student != null ? student['nombre'] : 'Desconocido',
            'grade': student != null ? student['curso'] : 'N/A',
            'time': time,
            'authorizedBy': thirdParty != null 
                ? "${thirdParty['nombre']} (${thirdParty['relacion'] ?? 'Tercero'})" 
                : 'Tutor Principal',
            'guardName': guard != null ? guard['nombre_completo'] : 'Sistema', 
            'isFlagged': log['estado'] == 'Alerta',
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

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay datos para exportar')));
      return;
    }
    await CsvExporter.exportHistory(filteredList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reporte exportado correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Historial de Retiros', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.deepPurple),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Column(
              children: [
                // Resumen superior
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Actividad Reciente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        decoration: BoxDecoration(
                          color: (_selectedDate != null || _selectedStatus != 'Todos') ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.tune_rounded,
                                color: (_selectedDate != null || _selectedStatus != 'Todos') ? Colors.deepPurple : Colors.grey.shade700,
                              ),
                              onPressed: _showFilterDialog,
                            ),
                            if (_selectedDate != null || _selectedStatus != 'Todos')
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Cartas de Resumen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      _buildSummaryCard(_todayCount.toString(), "Total Hoy", Colors.deepPurple, Colors.white),
                      const SizedBox(width: 16),
                      _buildSummaryCard("0", "Pendientes", Colors.orange.shade100, Colors.deepOrange.shade900),
                    ],
                  ),
                ),

                // Buscador y Fecha
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => setState(() => _searchQuery = value),
                            decoration: InputDecoration(
                              hintText: "Buscar estudiante...",
                              prefixIcon: const Icon(Icons.search_rounded, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedDate != null ? Colors.deepPurple : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: _selectedDate != null ? Colors.deepPurple.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                            border: Border.all(color: _selectedDate != null ? Colors.deepPurple : Colors.grey.shade200, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Icon(_selectedDate != null ? Icons.event_available_rounded : Icons.calendar_month_rounded, color: _selectedDate != null ? Colors.white : Colors.deepPurple, size: 22),
                              if (_selectedDate != null) ...[
                                const SizedBox(width: 8),
                                Text(DateFormat('dd/MM').format(_selectedDate!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedDate = null),
                                  child: const Icon(Icons.close_rounded, color: Colors.white70, size: 16),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de historial
                Expanded(
                  child: filteredList.isEmpty
                      ? const Center(child: Text("No se encontraron registros."))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return _buildHistoryCard(filteredList[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryCard(String value, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: bgColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    bool isFlagged = item['isFlagged'];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: isFlagged ? Colors.red.shade50 : Colors.deepPurple.shade50, child: Icon(isFlagged ? Icons.warning_rounded : Icons.person, color: isFlagged ? Colors.red : Colors.deepPurple)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['studentName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(item['grade'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: isFlagged ? Colors.red.shade50 : Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Text(isFlagged ? "Alerta" : "Exitoso", style: TextStyle(color: isFlagged ? Colors.red : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(item['time'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Aut: ${item['authorizedBy']}", style: const TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.security, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Guardia: ${item['guardName']}", style: const TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
