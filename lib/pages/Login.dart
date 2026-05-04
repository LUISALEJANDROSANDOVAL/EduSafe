import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'ParentDashboard.dart';
import 'AdminAnalyticsDashboard.dart';
import 'GuardScanner.dart';
import 'SignUp.dart';
import '../services/biometric_service.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
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

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu correo primero.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await SupabaseService().resetPassword(email);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Correo Enviado'),
            content: Text('Se ha enviado un enlace de recuperación a $email. Revisa también tu carpeta de spam.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleBiometricLogin() async {
    final biometricService = BiometricService();
    final isAvailable = await biometricService.isBiometricAvailable();
    
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometría no disponible en este dispositivo.')),
      );
      return;
    }

    try {
      final hash = await biometricService.authenticateAndGenerateHash(
        reason: 'Inicia sesión de forma segura con tu huella o rostro.'
      );

      if (hash != null) {
        setState(() => _isLoading = true);
        // En una app real, el hash se vincula al perfil previamente. 
        // Para el prototipo, si es exitoso, intentamos buscar el perfil o simulamos éxito si ya tenemos un correo.
        try {
          final profile = await SupabaseService().signInWithBiometrics(hash);
          _navigateToDashboard(profile['rol']);
        } catch (e) {
          // Fallback para demo: si no está vinculado, mostrar error educativo
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay una cuenta vinculada a esta biometría. Inicia sesión con contraseña primero.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de biometría: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToDashboard(String role) {
    if (role == 'Tutor') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ParentDashboardWidget()));
    } else if (role == 'Administrador') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminAnalyticsDashboardWidget()));
    } else if (role == 'Encargado') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GuardScannerWidget()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo / Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 64,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'SafeGuard School',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Seguridad y control en cada retiro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),

                // Selección de Rol
                const Text(
                  'Selecciona tu perfil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildRoleCard('Parent', Icons.family_restroom_rounded, 'Tutor'),
                    const SizedBox(width: 12),
                    _buildRoleCard('Guard', Icons.security_rounded, 'Seguridad'),
                    const SizedBox(width: 12),
                    _buildRoleCard('Admin', Icons.admin_panel_settings_rounded, 'Admin'),
                  ],
                ),
                const SizedBox(height: 32),

                // Formulario
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _passwordVisible = !_passwordVisible);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 32),

                // Botón Iniciar Sesión
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
                            if (!mounted) return;
                            _navigateToDashboard(realRole);
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
                  onPressed: _handleBiometricLogin,
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
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage())),
                      child: const Text('Crear cuenta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, IconData icon, String label) {
    bool isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
              width: 2,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.deepPurple.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
