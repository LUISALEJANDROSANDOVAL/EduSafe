import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminStudentManagementWidget extends StatefulWidget {
  const AdminStudentManagementWidget({super.key});

  static String routeName = 'AdminStudentManagement';

  @override
  State<AdminStudentManagementWidget> createState() =>
      _AdminStudentManagementWidgetState();
}

class _AdminStudentManagementWidgetState
    extends State<AdminStudentManagementWidget> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _allStudents = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  List<Map<String, dynamic>> _tutors = [];
  final TextEditingController _searchController = TextEditingController();
  
  final _nombreController = TextEditingController();
  final _ciEstudianteController = TextEditingController();
  final _cursoController = TextEditingController();
  final _ciTutorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nombreController.dispose();
    _ciEstudianteController.dispose();
    _cursoController.dispose();
    _ciTutorController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _allStudents.where((s) {
        return s['name'].toString().toLowerCase().contains(query) ||
               s['ci'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchStudents() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      
      // Fetch tutors first
      final tutorRes = await supabase.from('perfiles').select('id, nombre_completo, cedula_identidad').eq('rol', 'Tutor');
      List<Map<String, dynamic>> loadedTutors = List<Map<String, dynamic>>.from(tutorRes);

      // Fetch students without the join
      final response = await supabase.from('estudiantes').select('id, nombre, curso, cedula_identidad, pinata_foto_cid, tutor_id').order('creado_en', ascending: false);
      
      List<Map<String, dynamic>> loaded = [];
      for (var row in response) {
        String tutorName = 'Sin Asignar';
        String tutorCi = 'N/A';
        
        if (row['tutor_id'] != null) {
          final tutor = loadedTutors.firstWhere(
            (t) => t['id'] == row['tutor_id'],
            orElse: () => <String, dynamic>{},
          );
          if (tutor.isNotEmpty) {
            tutorName = tutor['nombre_completo'] ?? 'Sin Asignar';
            tutorCi = tutor['cedula_identidad'] ?? 'N/A';
          }
        }
        
        loaded.add({
          'id': row['id'].toString().substring(0, 8),
          'rawId': row['id'],
          'name': row['nombre'],
          'ci': row['cedula_identidad'] ?? 'S/C',
          'grade': row['curso'],
          'tutor': tutorName,
          'tutorCI': tutorCi,
          'status': 'Registrado',
          'photo': row['pinata_foto_cid'] != null ? 'https://gateway.pinata.cloud/ipfs/${row['pinata_foto_cid']}' : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(row['nombre'])}',
          'attendance': '100%',
          'lastPickup': 'Ver detalles',
        });
      }

      if (mounted) {
        setState(() {
          _allStudents = loaded;
          _filteredStudents = loaded;
          _tutors = loadedTutors;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching students: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cargar datos: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _showAddStudentModal() {
    _nombreController.clear();
    _ciEstudianteController.clear();
    _cursoController.clear();
    String? localSelectedTutorId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Registrar Nuevo Estudiante',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
              const SizedBox(height: 16),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo del Estudiante',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ciEstudianteController,
                decoration: InputDecoration(
                  labelText: 'CI del Estudiante (Opcional)',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cursoController,
                decoration: InputDecoration(
                  labelText: 'Grado / Curso',
                  prefixIcon: const Icon(Icons.class_),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: localSelectedTutorId,
                decoration: InputDecoration(
                  labelText: 'Seleccionar Padre/Tutor',
                  prefixIcon: const Icon(Icons.family_restroom),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _tutors.isEmpty 
                  ? [const DropdownMenuItem<String>(value: null, child: Text('No hay tutores o recargue la página', overflow: TextOverflow.ellipsis))]
                  : _tutors.map((t) {
                      return DropdownMenuItem<String>(
                        value: t['id'].toString(),
                        child: Text(
                          '${t['nombre_completo'] ?? 'Sin Nombre'} (CI: ${t['cedula_identidad'] ?? 'S/C'})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                onChanged: _tutors.isEmpty ? null : (val) {
                  setModalState(() {
                    localSelectedTutorId = val;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_nombreController.text.isEmpty || _cursoController.text.isEmpty || localSelectedTutorId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Llene nombre, grado y seleccione un tutor')));
                    return;
                  }
                  try {
                    final supabase = Supabase.instance.client;
                    await supabase.from('estudiantes').insert({
                      'tutor_id': localSelectedTutorId,
                      'nombre': _nombreController.text,
                      'curso': _cursoController.text,
                      'cedula_identidad': _ciEstudianteController.text.isEmpty ? null : _ciEstudianteController.text,
                    });
                    if (mounted) Navigator.pop(context);
                    _fetchStudents();
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estudiante registrado exitosamente.'), backgroundColor: Colors.green));
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Guardar Estudiante',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  Widget _buildStudentCard(Map<String, dynamic> student) {
    bool isRegistered = student['status'] == 'Registrado';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showStudentDetailAdmin(student),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(student['photo']),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          const SizedBox(height: 4),
                          Text('ID: ${student['id']} • CI: ${student['ci']}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ),
                    _buildStatusChip(student['status'], isRegistered),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn('Grado', student['grade'], Icons.class_outlined),
                    _buildInfoColumn('Asistencia', student['attendance'], Icons.analytics_outlined),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isSuccess) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: isSuccess ? Colors.green.shade700 : Colors.orange.shade700, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade400),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  void _showStudentDetailAdmin(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(radius: 60, backgroundImage: NetworkImage(student['photo'])),
                    const SizedBox(height: 16),
                    Text(student['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),
                    
                    _buildAdminDetailSection('Información del Tutor', [
                      {'label': 'Nombre', 'value': student['tutor']},
                      {'label': 'Cédula', 'value': student['tutorCI']},
                      {'label': 'Relación', 'value': 'Padre/Madre'},
                    ]),
                    const SizedBox(height: 16),
                    _buildAdminDetailSection('Actividad Reciente', [
                      {'label': 'Último Registro', 'value': student['lastPickup']},
                      {'label': 'Puerta de Salida', 'value': 'Principal - Sector A'},
                      {'label': 'Guardia', 'value': 'R. Mendez'},
                    ]),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Editar Datos'),
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.history),
                            label: const Text('Historial'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          ),
                        ),
                      ],
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

  Widget _buildAdminDetailSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
          child: Column(
            children: items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['label']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  Text(item['value']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            )).toList(),
          ),
        ),
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
                        'Gestión de Estudiantes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to center title
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Directorio de Alumnos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Administra los estudiantes y sus tutores asociados.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                    hintText: 'Buscar por nombre o CI...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Expanded(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredStudents.isEmpty 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school_rounded, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'No hay estudiantes',
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _filteredStudents.length,
                          itemBuilder: (context, index) {
                            return _buildStudentCard(_filteredStudents[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentModal,
        backgroundColor: const Color(0xFF673AB7),
        elevation: 8,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Estudiante',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
