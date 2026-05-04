import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Tutor';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await SupabaseService().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nombreCompleto: _nameController.text.trim(),
        rol: _selectedRole,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada exitosamente. Ya puedes iniciar sesión.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Crear Cuenta', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Únete a SafeGuard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Registra tus datos para comenzar.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (val) => val == null || !val.contains('@') ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (val) => val == null || val.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Tipo de Perfil',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                items: ['Tutor', 'Encargado', 'Administrador'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Crear Cuenta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
