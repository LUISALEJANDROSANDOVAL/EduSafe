import 'package:flutter/material.dart';
import 'ParentDashboard.dart';
import 'AdminAnalyticsDashboard.dart';
import 'GuardScanner.dart';

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
                      'Nurturing Safety, Ensuring Care',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- MENSAJE DE BIENVENIDA ---
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please select your role and sign in',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // --- SELECCIÓN DE ROL ---
                const Text(
                  'I am a...',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _buildRoleCard(
                  title: 'Parent / Tutor',
                  description: 'Manage children & authorizations',
                  icon: Icons.family_restroom_rounded,
                  isSelected: _selectedRole == 'Parent',
                  onTap: () => setState(() => _selectedRole = 'Parent'),
                ),
                _buildRoleCard(
                  title: 'Security Guard',
                  description: 'Scan QR & validate identity',
                  icon: Icons.shield_rounded,
                  isSelected: _selectedRole == 'Guard',
                  onTap: () => setState(() => _selectedRole = 'Guard'),
                ),
                _buildRoleCard(
                  title: 'Administrator',
                  description: 'Reports & school management',
                  icon: Icons.admin_panel_settings_rounded,
                  isSelected: _selectedRole == 'Admin',
                  onTap: () => setState(() => _selectedRole = 'Admin'),
                ),
                const SizedBox(height: 24),

                // --- FORMULARIO DE LOGIN ---
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'parent@school.com',
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
                    labelText: 'Password',
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
                    child: const Text('Forgot Password?', style: TextStyle(color: Colors.deepPurple)),
                  ),
                ),
                const SizedBox(height: 10),

                // --- BOTONES DE ACCIÓN ---
                ElevatedButton(
                  onPressed: () {
                    // Lógica de inicio de sesión y enrutamiento
                    if (_selectedRole == 'Parent') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ParentDashboardWidget()),
                      );
                    } else if (_selectedRole == 'Admin') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminAnalyticsDashboardWidget()),
                      );
                    } else if (_selectedRole == 'Guard') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const GuardScannerWidget()),
                      );
                    } else {
                      print("Iniciando sesión como \$_selectedRole (Falta implementar destino)");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
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
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
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
                  label: const Text('Sign in with Biometrics', style: TextStyle(color: Colors.deepPurple)),
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
                    const Text('New to SafeGuard?', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Contact Admin',
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
