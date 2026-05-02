import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Ingreso Exitoso',
      'message': 'Mateo García ha ingresado al colegio correctamente.',
      'time': 'hace 2h',
      'type': 'success',
      'isRead': false,
      'icon': Icons.check_circle_rounded,
    },
    {
      'id': '2',
      'title': 'Tercero Registrado',
      'message': 'Carlos Mendoza ha completado su registro biométrico exitosamente.',
      'time': 'hace 5h',
      'type': 'info',
      'isRead': false,
      'icon': Icons.person_add_alt_1_rounded,
    },
    {
      'id': '3',
      'title': 'Alerta de Seguridad',
      'message': 'Se detectó un intento de escaneo con un QR expirado en la Puerta B.',
      'time': 'Ayer',
      'type': 'warning',
      'isRead': true,
      'icon': Icons.warning_amber_rounded,
    },
    {
      'id': '4',
      'title': 'Actualización de Sistema',
      'message': 'EduSafe se ha actualizado a la versión 1.2.0 con mejoras en el motor facial.',
      'time': '2 días',
      'type': 'system',
      'isRead': true,
      'icon': Icons.system_update_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Notificaciones', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['isRead'] = true;
                }
              });
            },
            child: const Text('Marcar todo como leído', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filtros Rápidos
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Todas', true),
                  _buildFilterChip('Seguridad', false),
                  _buildFilterChip('Académico', false),
                  _buildFilterChip('Sistema', false),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple : Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.deepPurple,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    Color typeColor;
    switch (notification['type']) {
      case 'success': typeColor = Colors.green; break;
      case 'warning': typeColor = Colors.orange; break;
      case 'info': typeColor = Colors.blue; break;
      default: typeColor = Colors.deepPurple;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(notification['isRead'] ? 0.02 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: notification['isRead'] ? null : Border.all(color: typeColor.withOpacity(0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => notification['isRead'] = true);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notification['icon'], color: typeColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: notification['isRead'] ? Colors.black87 : Colors.black,
                            ),
                          ),
                          Text(
                            notification['time'],
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification['isRead'])
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: CircleAvatar(radius: 4, backgroundColor: typeColor),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
