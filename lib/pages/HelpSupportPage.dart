import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ayuda y Soporte', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Cómo podemos ayudarte?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar temas de ayuda...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Preguntas Frecuentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildFaqItem('¿Cómo autorizo a un tercero?', 'Ve al inicio, haz clic en "Autorizar", ingresa su correo y recibirán un enlace de registro.'),
            _buildFaqItem('¿Qué pasa si mi código QR expira?', 'Los códigos QR son dinámicos y se actualizan cada 45 segundos por seguridad. Solo espera el siguiente.'),
            _buildFaqItem('¿Cómo se usan los datos biométricos?', 'Las fotos faciales solo se usan para verificar la identidad en la entrada del colegio y se almacenan de forma segura.'),
            
            const SizedBox(height: 40),
            const Text('¿Aún necesitas ayuda?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.headset_mic_rounded, color: Colors.deepPurple, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contactar a Soporte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Disponible Lun-Vie, 8am - 6pm', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Chat', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Text(answer, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ),
      ],
      tilePadding: EdgeInsets.zero,
    );
  }
}
