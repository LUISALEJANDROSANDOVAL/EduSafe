import 'package:flutter/material.dart';
import 'PersonalInfoPage.dart';
import 'SecurityCenterPage.dart';
import 'HelpSupportPage.dart';
import 'Login.dart';
import 'BiometricsPage.dart';
import '../services/supabase_service.dart';

class UserProfileSettingsWidget extends StatefulWidget {
  const UserProfileSettingsWidget({super.key});

  static String routeName = 'UserProfileSettings';

  @override
  State<UserProfileSettingsWidget> createState() => _UserProfileSettingsWidgetState();
}

class _UserProfileSettingsWidgetState extends State<UserProfileSettingsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _supabaseService = SupabaseService();
  
  Map<String, dynamic>? _profile;
  Map<String, int> _stats = {'students': 0, 'thirdParties': 0, 'deliveries': 0};
  bool _isLoading = true;

  bool _notificationsEnabled = true;
  bool _emailAlertsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      if (profile != null) {
        final stats = await _supabaseService.getTutorStats(profile['id']);
        setState(() {
          _profile = profile;
          _stats = stats;
        });
      }
    } catch (e) {
      print("Error cargando perfil: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSettingTile({required String title, required String subtitle, required IconData icon, VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.deepPurple.shade50, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.deepPurple, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.deepPurple)));
    }

    final String name = _profile?['nombre_completo'] ?? "Usuario";
    final String role = _profile?['rol'] ?? "Tutor";

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Degradado y Tarjeta Superpuesta
            SizedBox(
              height: 320,
              child: Stack(
                children: [
                  Container(
                    height: 260,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.deepPurple],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Text("Perfil de Usuario", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name, 
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Padre / $role", 
                              style: const TextStyle(
                                color: Colors.indigo, 
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard("Hijos", _stats['students'].toString()),
                              _buildStatCard("Autorizados", _stats['thirdParties'].toString()),
                              _buildStatCard("Entregas", _stats['deliveries'].toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Opciones de Configuración
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cuenta y Seguridad
                  const Text("Cuenta y Seguridad", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildSettingTile(
                    title: "Información Personal", 
                    subtitle: "DNI, Teléfono, Dirección", 
                    icon: Icons.person_outline_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoPage())),
                  ),
                  _buildSettingTile(
                    title: "Biometría",
                    subtitle: "Configurar huella o rostro",
                    icon: Icons.fingerprint_rounded,
                  ),
                  const SizedBox(height: 24),

                  // Preferencias
                  const Text("Preferencias", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text("Notificaciones Push", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          value: _notificationsEnabled,
                          activeColor: Colors.deepPurple,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) => setState(() => _notificationsEnabled = val),
                        ),
                        const Divider(height: 0),
                        SwitchListTile(
                          title: const Text("Alertas por Correo", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          value: _emailAlertsEnabled,
                          activeColor: Colors.deepPurple,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) => setState(() => _emailAlertsEnabled = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Aplicación
                  const Text("Aplicación", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildSettingTile(
                    title: "Centro de Seguridad", 
                    subtitle: "Políticas y privacidad", 
                    icon: Icons.shield_outlined,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityCenterPage())),
                  ),
                  _buildSettingTile(
                    title: "Ayuda y Soporte", 
                    subtitle: "Preguntas frecuentes", 
                    icon: Icons.help_outline_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportPage())),
                  ),
                  const SizedBox(height: 32),

                  // Cerrar Sesión
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        // Llamar a Supabase para cerrar sesión
                        await _supabaseService.signOut();
                        
                        // Limpiar historial de navegación y volver al Login
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreenWidget()),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      label: const Text("Cerrar Sesión", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        backgroundColor: Colors.red.shade50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
