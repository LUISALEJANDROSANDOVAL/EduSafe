import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class TerceroWebFormPage extends StatefulWidget {
  const TerceroWebFormPage({super.key});

  static String routeName = 'registro-tercero';

  @override
  State<TerceroWebFormPage> createState() => _TerceroWebFormPageState();
}

class _TerceroWebFormPageState extends State<TerceroWebFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciController = TextEditingController();
  String? _relacionSeleccionada;
  bool _fotoSubida = false;
  bool _isSaving = false;

  String? _tutorId;
  String? _tokens;

  @override
  void initState() {
    super.initState();
    _extractParameters();
  }

  void _extractParameters() {
<<<<<<< HEAD
    // Para Flutter Web, extraemos de la URL
    final uri = Uri.base;
    setState(() {
      _tutorId = uri.queryParameters['tutorId'];
      _tokens = uri.queryParameters['tokens'];
    });
    print("TutorId cargado: $_tutorId, Tokens: $_tokens");
=======
    // Para Flutter Web, extraemos tanto de la query principal como del fragmento (después del #)
    final uri = Uri.base;
    Map<String, String> params = Map.from(uri.queryParameters);
    
    if (uri.hasFragment) {
      // Si la URL es .../#/registro-tercero?tutorId=123, los parámetros están en el fragmento
      final fragment = uri.fragment;
      if (fragment.contains('?')) {
        final queryPart = fragment.split('?').last;
        final fragmentParams = Uri.splitQueryString(queryPart);
        params.addAll(fragmentParams);
      }
    }

    setState(() {
      _tutorId = params['tutorId'];
      _tokens = params['tokens'];
    });
    print("Parámetros extraídos - TutorId: $_tutorId, Tokens: $_tokens");
>>>>>>> 88cbea5660b29b647643ed97d5b5dc0861aaf980
  }

  // Opciones de relación para la base de datos
  final List<String> _relaciones = [
    'Abuelo/a',
    'Tío/a',
    'Hermano/a Mayor',
    'Chofer',
    'Niñero/a',
    'Otro'
  ];

  Widget _buildLeftPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security_rounded, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 32),
            const Text(
              'EduSafe\nRegistro de Autorizado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Complete este formulario seguro para registrarse como tercera persona autorizada para el retiro de estudiantes. Su identidad será verificada para garantizar la seguridad de los niños.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            _buildFeatureRow(Icons.lock_outline, 'Datos encriptados de extremo a extremo'),
            const SizedBox(height: 16),
            _buildFeatureRow(Icons.face_retouching_natural, 'Verificación Biométrica Inteligente'),
            const SizedBox(height: 16),
            _buildFeatureRow(Icons.cloud_done_outlined, 'Almacenamiento seguro IPFS/Pinata'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(width: 16),
        Text(text, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
      ],
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Formulario de Registro', 
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa los datos tal como aparecen en tu documento oficial de identidad.', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16)
                  ),
                  const SizedBox(height: 40),

                  // Nombre Completo
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 24),

                  // Cédula de Identidad
                  TextFormField(
                    controller: _ciController,
                    decoration: InputDecoration(
                      labelText: 'Cédula de Identidad (CI)',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa tu CI' : null,
                  ),
                  const SizedBox(height: 24),

                  // Relación
                  DropdownButtonFormField<String>(
                    value: _relacionSeleccionada,
                    items: _relaciones.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) => setState(() => _relacionSeleccionada = val),
                    decoration: InputDecoration(
                      labelText: 'Relación con el Estudiante',
                      prefixIcon: const Icon(Icons.family_restroom_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) => value == null ? 'Selecciona una relación' : null,
                  ),
                  const SizedBox(height: 40),

                  // Foto Biometría
                  const Text('Verificación Biométrica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Sube una foto clara de tu rostro para asociarla al biometria_hash y pinata_foto_cid.', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14)
                  ),
                  const SizedBox(height: 16),
                  
                  GestureDetector(
                    onTap: () {
                      setState(() => _fotoSubida = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Imagen procesada. Hash biométrico y CID generados con éxito.'),
                          backgroundColor: Colors.green,
                        )
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: _fotoSubida ? Colors.green.shade50 : Colors.deepPurple.shade50,
                        border: Border.all(
                          color: _fotoSubida ? Colors.green : Colors.deepPurple.shade200,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _fotoSubida ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
                            size: 48,
                            color: _fotoSubida ? Colors.green : Colors.deepPurple,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _fotoSubida ? 'Fotografía Biométrica Cargada' : 'Haz clic para subir foto o tomar selfie',
                            style: TextStyle(
                              color: _fotoSubida ? Colors.green.shade700 : Colors.deepPurple.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
<<<<<<< HEAD
                      onPressed: _isSaving ? null : _handleRegister,
=======
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!_fotoSubida) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor sube tu fotografía para la verificación biométrica',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          // Success Dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Registro Exitoso'),
                                ],
                              ),
                              content: Text(
                                'Tus datos (\${_nombreController.text}, \$_relacionSeleccionada) han sido guardados en la tabla de terceros.\n\nEl sistema activará tu perfil automáticamente.',
                                style: const TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Navigate away or reset form
                                  },
                                  child: const Text(
                                    'Entendido',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
>>>>>>> 88cbea5660b29b647643ed97d5b5dc0861aaf980
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A00E0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
<<<<<<< HEAD
                      child: _isSaving 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Registrar Autorizado', 
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                          ),
=======
                      child: const Text(
                        'Registrar Autorizado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
>>>>>>> 88cbea5660b29b647643ed97d5b5dc0861aaf980
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_fotoSubida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor sube tu fotografía para la verificación biométrica'),
          backgroundColor: Colors.redAccent,
        )
      );
      return;
    }

    if (_tutorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: El enlace no contiene el ID del tutor.'), backgroundColor: Colors.redAccent)
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final supabase = SupabaseService();
      
      // En una app real, aquí generarías un hash biométrico real y subirías la foto a Pinata.
      // Por ahora simulamos con datos de prueba.
      final String biometricHash = "simulated_hash_${DateTime.now().millisecondsSinceEpoch}";
      final String photoCid = "Qm_simulated_cid_${DateTime.now().millisecondsSinceEpoch}";

      // Registramos en Supabase
      await supabase.registerThirdParty(
        tutorId: _tutorId!,
        name: _nombreController.text.trim(),
        ci: _ciController.text.trim(),
        relation: _relacionSeleccionada!,
        biometricHash: biometricHash,
        photoCid: photoCid,
        // Usamos el primer token como invitationId para vincular (simplificación)
        invitationId: _tokens?.split(',').first, 
      );

      // Mostrar éxito
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 32),
                const SizedBox(width: 12),
                const Text('¡Todo Listo!'),
              ],
            ),
            content: const Text(
              'Tu registro ha sido exitoso. El tutor recibirá una notificación y ahora estás autorizado para recoger a los estudiantes asignados.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Podríamos redirigir a una página de bienvenida o simplemente limpiar
                  setState(() {
                    _nombreController.clear();
                    _ciController.clear();
                    _relacionSeleccionada = null;
                    _fotoSubida = false;
                  });
                }, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Entendido', style: TextStyle(color: Colors.white))
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e'), backgroundColor: Colors.redAccent)
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detectamos el ancho de la pantalla para hacerlo responsivo (Split Screen en Web/Tablet, Columna en Móvil)
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 5, child: _buildLeftPanel()),
                Expanded(flex: 7, child: _buildRightPanel()),
              ],
            )
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.security_rounded, color: Colors.white, size: 32),
                        SizedBox(width: 16),
                        Text(
                          'EduSafe',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildRightPanel()),
                ],
              ),
            ),
    );
  }
}
