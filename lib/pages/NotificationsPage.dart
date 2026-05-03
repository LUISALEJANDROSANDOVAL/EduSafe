import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  String _selectedFilter = 'Todas';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      if (profile != null) {
        print("🔔 Cargando notificaciones para: ${profile['id']}");
        
        // MOSTRAR ID EN LA APP PARA PRUEBAS
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cargando datos para: ${profile['correo']}'), duration: const Duration(seconds: 2)),
        );

        final data = await _supabaseService.getUserNotifications(profile['id']);
        print("📈 Se encontraron ${data.length} notificaciones.");
        setState(() {
          _notifications = data;
          _isLoading = false;
        });
      } else {
        print("❌ No se pudo cargar el perfil para las notificaciones.");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error fetching notifications: $e");
      setState(() => _isLoading = false);
    }
  }

  String _formatTime(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    if (diff.inDays == 1) return 'Ayer';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'success': return Icons.check_circle_rounded;
      case 'warning': return Icons.warning_amber_rounded;
      case 'info': return Icons.person_add_alt_1_rounded;
      case 'system': return Icons.system_update_rounded;
      case 'seguridad': return Icons.security_rounded;
      case 'académico': return Icons.school_rounded;
      default: return Icons.notifications_active_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar notificaciones localmente
    final filteredNotifications = _selectedFilter == 'Todas' 
        ? _notifications 
        : _notifications.where((n) => n['tipo'].toString().toLowerCase() == _selectedFilter.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Notificaciones', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () async {
              final profile = await _supabaseService.getCurrentUserProfile();
              if (profile != null) {
                await _supabaseService.markAllNotificationsAsRead(profile['id']);
                _fetchNotifications();
              }
            },
            child: const Text('Marcar todo como leído', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
        : Column(
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
                      _buildFilterChip('Todas'),
                      _buildFilterChip('Seguridad'),
                      _buildFilterChip('Académico'),
                      _buildFilterChip('Sistema'),
                    ],
                  ),
                ),
              ),
              
              Expanded(
                child: filteredNotifications.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text('No tienes notificaciones', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
              ),
            ],
          ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
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
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final bool isRead = notification['leida'] ?? false;
    final String type = notification['tipo'] ?? 'info';
    
    Color typeColor;
    switch (type.toLowerCase()) {
      case 'success': typeColor = Colors.green; break;
      case 'warning': typeColor = Colors.orange; break;
      case 'info': typeColor = Colors.blue; break;
      case 'seguridad': typeColor = Colors.red; break;
      default: typeColor = Colors.deepPurple;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isRead ? 0.02 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isRead ? null : Border.all(color: typeColor.withOpacity(0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (!isRead) {
              await _supabaseService.markNotificationAsRead(notification['id']);
              _fetchNotifications();
            }
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
                  child: Icon(_getIconForType(type), color: typeColor, size: 24),
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
                            notification['titulo'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isRead ? Colors.black87 : Colors.black,
                            ),
                          ),
                          Text(
                            _formatTime(notification['creada_en']),
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['mensaje'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead)
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
