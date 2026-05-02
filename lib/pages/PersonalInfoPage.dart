import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await SupabaseService().getCurrentUserProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile['nombre_completo'] ?? '';
        _dniController.text = profile['cedula_identidad'] ?? '';
        _phoneController.text = profile['telefono'] ?? '';
        _emailController.text = profile['correo'] ?? '';
      });
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Información Personal', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildField('Nombre Completo', _nameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildField('DNI / Identificación (Inmutable)', _dniController, Icons.badge_outlined, readOnly: true),
            const SizedBox(height: 16),
            _buildField('Número de Teléfono', _phoneController, Icons.phone_android_rounded),
            const SizedBox(height: 16),
            _buildField('Correo Electrónico', _emailController, Icons.email_outlined),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () async {
                  setState(() => _isSaving = true);
                  try {
                    final profile = await SupabaseService().getCurrentUserProfile();
                    if (profile != null) {
                      await SupabaseService().updateUserProfile(
                        id: profile['id'],
                        nombreCompleto: _nameController.text.trim(),
                        // La cédula de identidad es inmutable, no la actualizamos
                        telefono: _phoneController.text.trim(),
                        correo: _emailController.text.trim(),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cambios guardados exitosamente en la base de datos'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar: ${e.toString().replaceAll('Exception: ', '')}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } finally {
                    if (context.mounted) {
                      setState(() => _isSaving = false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Guardar Cambios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          style: TextStyle(color: readOnly ? Colors.grey.shade600 : Colors.black),
          decoration: InputDecoration(
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade100 : Colors.transparent,
            prefixIcon: Icon(icon, color: readOnly ? Colors.grey : Colors.deepPurple),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: BorderSide(color: readOnly ? Colors.grey : Colors.deepPurple, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
