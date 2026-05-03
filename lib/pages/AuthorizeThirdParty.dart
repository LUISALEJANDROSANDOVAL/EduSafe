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
  
  // Datos simulados para la demostración
  final List<Map<String, dynamic>> _authorizedPersons = [
    {
      'id': '1',
      'name': 'Carlos Mendoza',
      'relation': 'Tío',
      'status': 'Activo',
      'email': 'carlos@email.com',
      'photo': 'https://i.pravatar.cc/150?u=carlos',
    },
    {
      'id': '2',
      'name': 'Pendiente de Registro',
      'relation': 'Transporte',
      'status': 'Pendiente',
      'email': 'maria.transporte@gmail.com',
      'photo': null,
    },
    {
      'id': '3',
      'name': 'Roberto Gomez',
      'relation': 'Abuelo',
      'status': 'Activo',
      'email': 'roberto.g@email.com',
      'photo': 'https://i.pravatar.cc/150?u=roberto',
    },
  ];

  void _showQRModal(Map<String, dynamic> person) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 32),
            const Text('Código de Autorización', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Válido para: ${person['name']}', style: TextStyle(color: Colors.grey.shade600)),
            const Spacer(),
            // Simulación de QR Dinámico
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.deepPurple.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)],
              ),
              child: Column(
                children: [
                  Icon(Icons.qr_code_2_rounded, size: 240, color: Colors.deepPurple.shade800),
                  const SizedBox(height: 16),
                  const Text('14:45:02', style: TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Muestra este código al guardia para validar la salida de $_selectedChild.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Código QR enviado a ${person['name']} exitosamente'),
                            backgroundColor: Colors.deepPurple,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      label: const Text('Enviar QR a Tercero', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Cerrar', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Autorizar Tercero', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // SECCIÓN SUPERIOR: FORMULARIO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nueva Invitación', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('Envía un enlace seguro para que el tercero registre sus datos.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 24),
                  
                  // Selección de Hijo
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChildChip('Mateo Garcia', '2do Grado', 'https://i.pravatar.cc/150?u=mateo'),
                        const SizedBox(width: 12),
                        _buildChildChip('Sofia Garcia', 'Kinder', 'https://i.pravatar.cc/150?u=sofia'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Campo de Email
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Correo del tercero...',
                        prefixIcon: const Icon(Icons.mail_outline_rounded, color: Colors.deepPurple),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.deepPurple),
                          onPressed: () {
                            if (_emailController.text.contains('@')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('¡Invitación enviada con éxito!'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                              _emailController.clear();
                            }
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SECCIÓN INFERIOR: PERSONAS AUTORIZADAS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Personas Autorizadas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(12)),
                        child: Text('${_authorizedPersons.length} Total', style: const TextStyle(color: Colors.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final person = _authorizedPersons[index];
                  return _buildThirdPartyCard(person);
                },
                childCount: _authorizedPersons.length,
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildThirdPartyCard(Map<String, dynamic> person) {
    bool isPending = person['status'] == 'Pendiente';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isPending ? Colors.orange.shade100 : Colors.transparent),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isPending ? null : () => _showQRModal(person),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Foto de Perfil o Icono Pendiente
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isPending ? Colors.orange.shade50 : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: person['photo'] != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(person['photo'], fit: BoxFit.cover),
                      )
                    : Icon(
                        isPending ? Icons.hourglass_empty_rounded : Icons.person_rounded, 
                        color: isPending ? Colors.orange : Colors.deepPurple,
                        size: 30,
                      ),
                ),
                const SizedBox(width: 16),
                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person['name'], 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          color: isPending ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isPending ? Colors.orange.shade100 : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPending ? 'Pendiente' : 'Verificado',
                              style: TextStyle(
                                color: isPending ? Colors.orange.shade900 : Colors.green.shade900,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(person['relation'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón Acción
                if (!isPending)
                  const Icon(Icons.qr_code_scanner_rounded, color: Colors.deepPurple)
                else
                  Icon(Icons.mail_outline_rounded, color: Colors.grey.shade400, size: 20),
              ],
            ),
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
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade200, width: 2),
          boxShadow: isSelected ? [BoxShadow(color: Colors.deepPurple.withOpacity(0.1), blurRadius: 10)] : null,
        ),
        child: Column(
          children: [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
            Text(grade, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
