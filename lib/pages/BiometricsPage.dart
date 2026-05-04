import 'package:flutter/material.dart';
import '../services/biometric_service.dart';

class BiometricsPage extends StatefulWidget {
  const BiometricsPage({super.key});

  @override
  State<BiometricsPage> createState() => _BiometricsPageState();
}

class _BiometricsPageState extends State<BiometricsPage> {
  final _biometricService = BiometricService();
  bool _isFingerprintEnabled = true;
  bool _isFaceIDEnabled = false;
  bool _isBiometricAvailable = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final available = await _biometricService.isBiometricAvailable();
    setState(() => _isBiometricAvailable = available);
  }

  Future<void> _toggleBiometrics(String type, bool value) async {
    if (!value) {
      setState(() {
        if (type == 'fingerprint') _isFingerprintEnabled = false;
        if (type == 'face') _isFaceIDEnabled = false;
      });
      return;
    }

    setState(() => _isProcessing = true);
    
    // Simular autenticación real
    final hash = await _biometricService.authenticateAndGenerateHash(
      reason: 'Autentícate para habilitar el acceso con $type'
    );

    await Future.delayed(const Duration(seconds: 1)); // Simular delay de UX

    if (hash != null) {
      setState(() {
        if (type == 'fingerprint') _isFingerprintEnabled = true;
        if (type == 'face') _isFaceIDEnabled = true;
        _isProcessing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${type == 'fingerprint' ? 'Huella' : 'Rostro'} configurado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Biometría', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ilustración Superior
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fingerprint_rounded,
                  size: 80,
                  color: Colors.deepPurple.shade400,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            const Text(
              'Autenticación Segura',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Utiliza tus rasgos biométricos para acceder rápidamente a tu cuenta y autorizar retiros de forma segura.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16, height: 1.5),
            ),
            
            const SizedBox(height: 40),
            
            // Sección de Configuración
            _buildOptionCard(
              title: 'Huella Dactilar',
              subtitle: 'Disponible en este dispositivo',
              icon: Icons.fingerprint,
              value: _isFingerprintEnabled,
              onChanged: (val) => _toggleBiometrics('fingerprint', val),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              title: 'Reconocimiento Facial',
              subtitle: 'FaceID o escaneo de rostro',
              icon: Icons.face_unlock_rounded,
              value: _isFaceIDEnabled,
              onChanged: (val) => _toggleBiometrics('face', val),
            ),
            
            const SizedBox(height: 48),
            
            // Nota de Seguridad
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.blue.shade700),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacidad de Datos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tus datos biométricos nunca salen de tu dispositivo. EduSafe solo almacena un hash criptográfico SHA-256 anónimo para validaciones.',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: value ? Colors.deepPurple.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: value ? Colors.deepPurple : Colors.grey.shade400,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
