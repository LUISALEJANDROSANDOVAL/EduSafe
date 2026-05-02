import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  void _showActionMessage(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(action),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Ayuda y Soporte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.support_agent_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('¿En qué podemos ayudarte?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Busca temas de ayuda...',
                      prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.deepPurple),
                        onPressed: () => _showActionMessage(context, 'Abriendo búsqueda avanzada...'),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20), 
                        borderSide: BorderSide(color: Colors.grey.shade300)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20), 
                        borderSide: BorderSide(color: Colors.grey.shade300)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20), 
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 2)
                      ),
                    ),
                    onSubmitted: (value) => _showActionMessage(context, 'Buscando: $value'),
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('Preguntas Frecuentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: Column(
                      children: [
                        _buildFaqItem('¿Cómo autorizo a un tercero?', 'Ve al panel principal, haz clic en "Autorizar", ingresa su correo y recibirá un enlace de registro.'),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildFaqItem('¿Qué hago si mi código QR expira?', 'Los códigos QR son dinámicos y se actualizan cada 45 segundos por seguridad. Solo espera al siguiente o actualiza la pantalla.'),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildFaqItem('¿Cómo se usan mis datos biométricos?', 'Las fotos faciales solo se usan para verificar identidad en la puerta del colegio y se almacenan de manera encriptada y local cuando es posible.'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  const Text('¿Aún necesitas ayuda?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple.shade50, Colors.indigo.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.deepPurple.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.deepPurple, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Contactar Soporte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                              const SizedBox(height: 4),
                              Text('Lun-Vie, 8:00 AM - 6:00 PM', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showActionMessage(context, 'Vincúlate con un agente por chat...'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple, 
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showActionMessage(context, 'Llamando al área de soporte técnico...'),
                      icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.deepPurple),
                      label: const Text('Llamanos', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Colors.deepPurple,
        collapsedIconColor: Colors.grey.shade600,
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: Text(answer, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
