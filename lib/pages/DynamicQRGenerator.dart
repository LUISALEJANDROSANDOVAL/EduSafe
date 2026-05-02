import 'package:flutter/material.dart';
import 'dart:async';

class DynamicQRGeneratorWidget extends StatefulWidget {
  final String? thirdPartyName;
  const DynamicQRGeneratorWidget({super.key, this.thirdPartyName});

  static String routeName = 'DynamicQRGenerator';

  @override
  State<DynamicQRGeneratorWidget> createState() => _DynamicQRGeneratorWidgetState();
}

class _DynamicQRGeneratorWidgetState extends State<DynamicQRGeneratorWidget> {
  int _secondsLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        setState(() => _secondsLeft = 45);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isThirdParty = widget.thirdPartyName != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(isThirdParty ? 'QR de Tercero' : 'Mi QR de Recogida', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade50,
                    child: Icon(isThirdParty ? Icons.person_add_rounded : Icons.person_rounded, color: Colors.deepPurple),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isThirdParty ? 'Persona Autorizada' : 'Recogida Autorizada', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        Text(isThirdParty ? widget.thirdPartyName! : 'Mateo Garcia', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // QR Code Container
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  // Simulated QR Code
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.deepPurple.shade100, width: 2),
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, size: 180, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: _secondsLeft / 45,
                          strokeWidth: 3,
                          color: Colors.deepPurple,
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Se actualiza en \${_secondsLeft}s', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Válido solo para la recogida de hoy', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Additional Details
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.school_rounded, 'Estudiante', 'Mateo Lopez - 2do Grado A'),
                  const Divider(height: 32),
                  _buildDetailRow(Icons.schedule_rounded, 'Válido Hasta', 'Hoy, 4:30 PM'),
                  const Divider(height: 32),
                  _buildDetailRow(Icons.verified_user_rounded, 'Seguridad', 'Token Dinámico Encriptado'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Share Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                label: Text('Compartir QR con \${isThirdParty ? "Tercero" : "Autorizado"}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver al Inicio', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
