import 'package:flutter/material.dart';

class AuthorizeThirdPartyWidget extends StatefulWidget {
  const AuthorizeThirdPartyWidget({super.key});

  static String routeName = 'AuthorizeThirdParty';

  @override
  State<AuthorizeThirdPartyWidget> createState() => _AuthorizeThirdPartyWidgetState();
}

class _AuthorizeThirdPartyWidgetState extends State<AuthorizeThirdPartyWidget> {
  final _emailController = TextEditingController();
  String _selectedChild = 'Mateo Garcia';
  bool _isSent = false;

  @override
  Widget build(BuildContext context) {
    if (_isSent) {
      return _buildSuccessState();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Delegar Recogida', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enviar Enlace de Autorización', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('La persona autorizada recibirá un enlace seguro para proveer sus datos de identidad y fotos.', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            
            const SizedBox(height: 32),
            
            // Child Selection
            const Text('SELECCIONAR HIJO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChildChip('Mateo Garcia', '2do Grado', 'https://dimg.dreamflow.cloud/v1/image/school%20boy%20portrait'),
                  const SizedBox(width: 16),
                  _buildChildChip('Sofia Garcia', 'Kinder', 'https://dimg.dreamflow.cloud/v1/image/school%20girl%20portrait'),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Email Input
            const Text('CORREO DEL TERCERO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'ejemplo@correo.com',
                prefixIcon: const Icon(Icons.mail_outline_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Este método es más seguro y garantiza que la persona provea sus datos biométricos oficiales.',
                      style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Send Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (!_emailController.text.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor ingresa un correo válido')),
                    );
                    return;
                  }
                  setState(() => _isSent = true);
                },
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                label: const Text('Enviar Enlace de Invitación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text('¡Invitación Enviada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                'Se ha enviado un correo a \${_emailController.text}. Deben completar su registro antes de la recogida.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Volver al Inicio', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildChip(String name, String grade, String imageUrl) {
    bool isSelected = _selectedChild == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedChild = name),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          children: [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(grade, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
