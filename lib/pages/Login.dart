import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';
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
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isLoading = false;

  // Estado para la tarjeta de rol seleccionada
  String _selectedRole = 'Parent';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticateBiometrics() async {
    try {
      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La biometría no funciona en navegadores web (Edge/Chrome). Prueba en un celular.')));
        return;
      }

      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometría no disponible en este dispositivo')));
        return;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Por favor, autentícate para iniciar sesión en EduSafe',
      );

      if (didAuthenticate && mounted) {
        // Here we could fetch the stored credentials from secure storage.
        // For now, we simulate a successful login as an administrator or fallback.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Autenticación exitosa. Redirigiendo...')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminAnalyticsDashboardWidget()), // Default fallback for biometrics
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showForgotPasswordModal() {
    final emailCtrl = TextEditingController();
    final ciCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Restablecer Contraseña', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Correo electrónico', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: ciCtrl, decoration: const InputDecoration(labelText: 'Cédula de Identidad', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Nueva Contraseña', border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await SupabaseService().updatePassword(email: emailCtrl.text.trim(), ci: ciCtrl.text.trim(), newPassword: passCtrl.text);
                    if (mounted) Navigator.pop(context);
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada.')));
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                  }
                },
                child: const Text('Actualizar Contraseña'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showRegisterModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final ciCtrl = TextEditingController();
    String localRole = 'Tutor';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Crear Cuenta Nueva', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: ciCtrl, decoration: const InputDecoration(labelText: 'Cédula de Identidad', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()), obscureText: true),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: localRole,
                    decoration: const InputDecoration(labelText: 'Rol', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Tutor', child: Text('Padre / Tutor')),
                      DropdownMenuItem(value: 'Encargado', child: Text('Guardia de Seguridad')),
                      DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => localRole = val);
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await SupabaseService().signUp(
                          fullName: nameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          password: passCtrl.text,
                          ci: ciCtrl.text.trim(),
                          role: localRole,
                        );
                        if (mounted) Navigator.pop(context);
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta creada con éxito. Ya puedes iniciar sesión.'), backgroundColor: Colors.green));
                      } catch (e) {
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
                    child: const Text('Registrarse', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        });
      },
    );
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
                    onPressed: _showForgotPasswordModal,
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
                  onPressed: _authenticateBiometrics,
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
                      onTap: _showRegisterModal,
                      child: const Text(
                        'Crear Cuenta',
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
