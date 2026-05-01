import 'package:flutter/material.dart';

class AdminGuardManagementWidget extends StatefulWidget {
  const AdminGuardManagementWidget({super.key});

  static String routeName = 'AdminGuardManagement';

  @override
  State<AdminGuardManagementWidget> createState() => _AdminGuardManagementWidgetState();
}

class _AdminGuardManagementWidgetState extends State<AdminGuardManagementWidget> {
  // Simulated list of guards
  final List<Map<String, dynamic>> _guards = [
    {
      'name': 'Carlos Rodriguez',
      'id': 'SEC-8942-A',
      'shift': 'Mañana (06:00 AM - 02:00 PM)',
      'status': 'Activo',
    },
    {
      'name': 'Luis Martinez',
      'id': 'SEC-8943-B',
      'shift': 'Tarde (02:00 PM - 10:00 PM)',
      'status': 'Fuera de Servicio',
    },
    {
      'name': 'Ana Silva',
      'id': 'SEC-8944-C',
      'shift': 'Noche (10:00 PM - 06:00 AM)',
      'status': 'De Permiso',
    }
  ];

  void _showAddGuardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
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
                  const Text('Agregar Guardia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'ID de Empleado',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Asignar Turno',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Morning', child: Text('Mañana (06:00 AM - 02:00 PM)')),
                  DropdownMenuItem(value: 'Afternoon', child: Text('Tarde (02:00 PM - 10:00 PM)')),
                  DropdownMenuItem(value: 'Night', child: Text('Noche (10:00 PM - 06:00 AM)')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Guardia registrado exitosamente en el sistema.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuardCard(Map<String, dynamic> guard) {
    Color statusColor;
    if (guard['status'] == 'Activo') statusColor = Colors.green;
    else if (guard['status'] == 'Fuera de Servicio') statusColor = Colors.grey;
    else statusColor = Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.security, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guard['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(guard['id'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  guard['status'],
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_filled, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(guard['shift'], style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple, size: 20),
                onPressed: () {
                  // Simulamos editar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Editar horario de ${guard["name"]}')),
                  );
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Gestión de Personal', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Guardias de Seguridad',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Gestiona horarios y permisos para el equipo de seguridad.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _guards.length,
                  itemBuilder: (context, index) {
                    return _buildGuardCard(_guards[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGuardModal,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Guardia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
