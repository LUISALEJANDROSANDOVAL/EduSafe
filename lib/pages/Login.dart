import 'package:flutter/material.dart';
import 'ParentDashboard.dart';
import 'AdminAnalyticsDashboard.dart';
import 'GuardScanner.dart';
import '../services/supabase_service.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  // Estado para la tarjeta de rol seleccionada
  String _selectedRole = 'Parent';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Widget personalizado para reemplazar el RoleCard de FlutterFlow
  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.deepPurple : Colors.grey, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Colors.deepPurple : Colors.black87,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.deepPurple)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // --- CABECERA (LOGO Y TÍTULO) ---
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.security_rounded, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SafeGuard School',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fomentando la Seguridad, Garantizando el Cuidado',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- MENSAJE DE BIENVENIDA ---
                const Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Por favor selecciona tu rol e inicia sesión',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // --- SELECCIÓN DE ROL ---
                const Text(
                  'Soy un...',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _buildRoleCard(
                  title: 'Padre / Tutor',
                  description: 'Gestionar hijos y autorizaciones',
                  icon: Icons.family_restroom_rounded,
                  isSelected: _selectedRole == 'Parent',
                  onTap: () => setState(() => _selectedRole = 'Parent'),
                ),
                _buildRoleCard(
                  title: 'Guardia de Seguridad',
                  description: 'Escanear QR y validar identidad',
                  icon: Icons.shield_rounded,
                  isSelected: _selectedRole == 'Guard',
                  onTap: () => setState(() => _selectedRole = 'Guard'),
                ),
                _buildRoleCard(
                  title: 'Administrador',
                  description: 'Reportes y gestión escolar',
                  icon: Icons.admin_panel_settings_rounded,
                  isSelected: _selectedRole == 'Admin',
                  onTap: () => setState(() => _selectedRole = 'Admin'),
                ),
                const SizedBox(height: 24),

                // --- FORMULARIO DE LOGIN ---
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'padre@colegio.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.deepPurple)),
                  ),
                ),
                const SizedBox(height: 10),

                // --- BOTONES DE ACCIÓN ---
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor, ingresa correo y contraseña.')),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);

                          try {
                            final profile = await SupabaseService().signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );

                            final String realRole = profile['rol'];
                            
                            // Map the selected UI role to the DB role
                            String expectedRole = '';
                            if (_selectedRole == 'Parent') expectedRole = 'Tutor';
                            if (_selectedRole == 'Guard') expectedRole = 'Encargado';
                            if (_selectedRole == 'Admin') expectedRole = 'Administrador';

                            if (realRole != expectedRole) {
                              // Sign out immediately if role is wrong
                              await SupabaseService().signOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Acceso denegado. Tu cuenta es de $realRole, pero seleccionaste $_selectedRole.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() => _isLoading = false);
                              return;
                            }

                            // Enrutamiento si es exitoso
                            if (!mounted) return;
                            
                            if (realRole == 'Tutor') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ParentDashboardWidget()),
                              );
                            } else if (realRole == 'Administrador') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminAnalyticsDashboardWidget()),
                              );
                            } else if (realRole == 'Encargado') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const GuardScannerWidget()),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al iniciar sesión: ${e.toString().replaceAll('Exception: ', '')}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      else ...[
                        const Text('Iniciar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // OR Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('O', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: () {
                    // Bypass biométrico
                    print("Biometría presionada");
                  },
                  icon: const Icon(Icons.fingerprint_rounded, color: Colors.deepPurple),
                  label: const Text('Iniciar sesión con Biometría', style: TextStyle(color: Colors.deepPurple)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nuevo usuario
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Nuevo en SafeGuard?', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Contactar Administrador',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Actualización de seguridad y diseño
