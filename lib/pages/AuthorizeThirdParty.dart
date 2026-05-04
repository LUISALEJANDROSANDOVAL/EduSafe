import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'dart:math';
import '../services/email_service.dart';

class AuthorizeThirdPartyWidget extends StatefulWidget {
  const AuthorizeThirdPartyWidget({super.key});

  static String routeName = 'AuthorizeThirdParty';

  @override
  State<AuthorizeThirdPartyWidget> createState() => _AuthorizeThirdPartyWidgetState();
}

class _AuthorizeThirdPartyWidgetState extends State<AuthorizeThirdPartyWidget> {
  final _supabaseService = SupabaseService();
  final _emailService = EmailService();
  final _emailController = TextEditingController();
  
  Set<String> _selectedChildIds = {}; // Cambiado a Set para selección múltiple
  List<Map<String, dynamic>> _children = [];
  List<Map<String, dynamic>> _authorizedPersons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      if (profile != null) {
        final children = await _supabaseService.getStudentsByTutor(profile['id']);
        final thirdParties = await _supabaseService.getAuthorizedThirdParties(profile['id']);
        final pendingInvs = await _supabaseService.getPendingInvitations(profile['id']);

        setState(() {
          _children = children;
          // Por defecto no seleccionamos ninguno o podrías seleccionar el primero
          _authorizedPersons = [
            ...thirdParties.map((p) => {...p, 'status': 'Verificado'}),
            ...pendingInvs.map((i) => {
              'id': i['id'],
              'name': i['correo_tercero'],
              'relation': 'Invitación enviada',
              'status': 'Pendiente',
              'email': i['correo_tercero'],
              'photo': null,
            }),
          ];
        });
      }
    } catch (e) {
      print("Error cargando datos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _generateSecureToken() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _sendInvitation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa un correo válido')));
      return;
    }

    if (_selectedChildIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos un hijo')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = await _supabaseService.getCurrentUserProfile();
      
      List<String> studentNames = [];
      List<String> tokens = [];
      
      print("🚀 Iniciando creación de invitaciones...");

      for (String childId in _selectedChildIds) {
        try {
          final uniqueToken = _generateSecureToken();
          await _supabaseService.createInvitation(
            tutorId: profile!['id'],
            estudianteId: childId,
            email: email,
            token: uniqueToken,
          );
          tokens.add(uniqueToken);
          
          final child = _children.firstWhere((c) => c['id'] == childId);
          studentNames.add(child['nombre']);
        } catch (dbError) {
          print("⚠️ Error guardando hijo $childId: $dbError");
          // Si ya existe o hay error, intentamos seguir con los demás
        }
      }

      if (tokens.isEmpty) {
        throw Exception("No se pudo crear ninguna invitación en la base de datos. Verifica el comando SQL en Supabase.");
      }

      final allTokens = tokens.join(",");
      final invitationLink = "https://edu-safe-tau.vercel.app/#/registro-tercero?tokens=$allTokens&tutorId=${profile!['id']}";
      
      final String allStudents = studentNames.join(", ");
      
      print("📧 Intentando enviar correo a $email para recoger a $allStudents...");

      final bool sent = await _emailService.enviarInvitacionEmail(
        toEmail: email,
        tutorName: profile['nombre_completo'] ?? 'Tutor de SafeGuard School',
        studentName: allStudents,
        invitationLink: invitationLink,
      );

      if (sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitación enviada para recoger a $allStudents'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      
      _emailController.clear();
      _selectedChildIds.clear(); // Limpiar selección
      _loadInitialData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al enviar: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
            Text('Válido para: ${person['nombre'] ?? person['name']}', style: TextStyle(color: Colors.grey.shade600)),
            const Spacer(),
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
                  const Text('TOKEN QR', style: TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
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
            ),
            const SizedBox(height: 32),
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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
        : CustomScrollView(
        slivers: [
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
                  
                  // Selección de Hijo Dinámica
                  if (_children.isEmpty)
                    const Text("No tienes hijos registrados.")
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _children.map((child) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildChildChip(
                            child['nombre'], 
                            child['curso'], 
                            child['id']
                          ),
                        )).toList(),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Correo del tercero...',
                        prefixIcon: const Icon(Icons.mail_outline_rounded, color: Colors.deepPurple),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.deepPurple),
                          onPressed: _sendInvitation,
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isPending ? Colors.orange.shade50 : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: person['pinata_foto_cid'] != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network("https://gateway.pinata.cloud/ipfs/${person['pinata_foto_cid']}", fit: BoxFit.cover),
                      )
                    : Icon(
                        isPending ? Icons.hourglass_empty_rounded : Icons.person_rounded, 
                        color: isPending ? Colors.orange : Colors.deepPurple,
                        size: 30,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person['nombre'] ?? person['name'], 
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
                          Text(person['relacion'] ?? person['relation'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
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

  Widget _buildChildChip(String name, String grade, String childId) {
    bool isSelected = _selectedChildIds.contains(childId);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedChildIds.remove(childId);
          } else {
            _selectedChildIds.add(childId);
          }
        });
      },
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
            CircleAvatar(
              radius: 24, 
              backgroundColor: isSelected ? Colors.deepPurple : Colors.grey.shade200, 
              child: Icon(Icons.person, color: isSelected ? Colors.white : Colors.grey)
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
            Text(grade, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
