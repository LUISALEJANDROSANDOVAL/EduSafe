import 'package:flutter/material.dart';
import 'UserProfileSettings.dart';
import 'PickupHistory.dart';
import 'DynamicQRGenerator.dart';
import 'AuthorizeThirdParty.dart';

class ParentDashboardWidget extends StatefulWidget {
  const ParentDashboardWidget({super.key});

  static String routeName = 'ParentDashboard';

  @override
  State<ParentDashboardWidget> createState() => _ParentDashboardWidgetState();
}

class _ParentDashboardWidgetState extends State<ParentDashboardWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildQuickAction({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard({required String name, required String grade}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(grade, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildRecentActivity({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hola, Familia García", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Lunes, 24 de Octubre", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.deepPurple, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileSettingsWidget()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        automaticallyImplyLeading: false, // Quitamos el boton back para el Home
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Principal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.white, size: 48),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Escuela Segura", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Todos tus hijos han ingresado correctamente hoy.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Acciones Rápidas
            const Text("Acciones Rápidas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction(
                  label: "Generar QR",
                  icon: Icons.qr_code_2_rounded,
                  iconColor: Colors.deepPurple,
                  bgColor: Colors.deepPurple.shade50,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DynamicQRGeneratorWidget()),
                    );
                  },
                ),
                _buildQuickAction(
                  label: "Autorizar",
                  icon: Icons.person_add_rounded,
                  iconColor: Colors.orange,
                  bgColor: Colors.orange.shade50,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthorizeThirdPartyWidget()),
                    );
                  },
                ),
                _buildQuickAction(
                  label: "Historial",
                  icon: Icons.history_rounded,
                  iconColor: Colors.purple,
                  bgColor: Colors.purple.shade50,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PickupHistoryWidget()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Mis Hijos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mis Hijos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Ver todos", style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildStudentCard(name: "Mateo García", grade: "4to Grado - Primaria"),
            _buildStudentCard(name: "Sofía García", grade: "2do Grado - Primaria"),
            const SizedBox(height: 32),

            // Actividad Reciente
            const Text("Actividad Reciente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildRecentActivity(
                    title: "Ingreso Escolar",
                    subtitle: "Mateo García • 07:45 AM",
                    icon: Icons.login_rounded,
                    bgColor: Colors.green.shade50,
                  ),
                  const Divider(height: 24),
                  _buildRecentActivity(
                    title: "Tercero Autorizado",
                    subtitle: "Abuela Elena fue autorizada para hoy",
                    icon: Icons.verified_user_rounded,
                    bgColor: Colors.orange.shade50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
