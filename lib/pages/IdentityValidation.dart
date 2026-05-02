import 'package:flutter/material.dart';

class IdentityValidationWidget extends StatefulWidget {
  const IdentityValidationWidget({super.key});

  static String routeName = 'IdentityValidation';

  @override
  State<IdentityValidationWidget> createState() => _IdentityValidationWidgetState();
}

class _IdentityValidationWidgetState extends State<IdentityValidationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildIdentityCard({
    required String title,
    required String name,
    required String role,
    required String idLabel,
    required String idValue,
    required String subtext,
    required String status,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(role, style: const TextStyle(color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('$idLabel: $idValue', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    Text(subtext, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Validación de Identidad', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 16),
            const Text('Código QR / Identidad Verificada', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Por favor realiza la verificación visual biométrica abajo.', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            
            _buildIdentityCard(
              title: 'Información del Estudiante',
              name: 'Mateo Fernández',
              role: 'ESTUDIANTE',
              idLabel: 'ID de Estudiante',
              idValue: 'ST-9920',
              subtext: 'Grado 4 - Sección B',
              status: 'Matriculado',
            ),
            const SizedBox(height: 24),
            _buildIdentityCard(
              title: 'Recogida Autorizada',
              name: 'Elena Rodríguez',
              role: 'TERCERO AUTORIZADO',
              idLabel: 'ID de Documento',
              idValue: 'DNI 48.291.XXX',
              subtext: 'Tía / Tutora Legal',
              status: 'Verificado',
            ),
            const SizedBox(height: 32),
            
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Confianza de Coincidencia Facial', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('98%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.98,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.red),
                    label: const Text('Denegar Entrada', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recogida confirmada exitosamente')),
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                    label: const Text('Confirmar Recogida', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
