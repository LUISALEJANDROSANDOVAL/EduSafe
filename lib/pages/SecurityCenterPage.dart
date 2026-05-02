import 'package:flutter/material.dart';

class SecurityCenterPage extends StatelessWidget {
  const SecurityCenterPage({super.key});

  void _showDocumentDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            children: [
              const Icon(Icons.description_outlined, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('Entendido y Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.grey.shade50,
=======
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Centro de Seguridad', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
>>>>>>> 6471b013fda23564e8df47e77326576b4c5aa486
      body: SingleChildScrollView(
        child: Column(
          children: [
<<<<<<< HEAD
            // Header
            Container(
              padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.shield_rounded, size: 80, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Centro de Seguridad',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tu seguridad es nuestra prioridad',
                          style: TextStyle(fontSize: 16, color: Colors.indigo.shade100),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'En EduSafe, utilizamos encriptación de grado militar y verificación biométrica para garantizar la seguridad de su familia.',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSecurityCard(
                    icon: Icons.lock_outline_rounded,
                    title: 'Encriptación de Datos',
                    description: 'Todos los datos personales y biométricos son guardados y encriptados bajo estrictos estándares antes de ser almacenados.',
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityCard(
                    icon: Icons.visibility_off_outlined,
                    title: 'Privacidad Garantizada',
                    description: 'Nunca compartimos tu información personal con terceros sin tu consentimiento explícito.',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Verificación Biométrica',
                    description: 'El reconocimiento facial se procesa de forma segura para proteger la identidad de todos los usuarios.',
                    color: Colors.orangeAccent,
                  ),
                  
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 24),
                  
                  const Text('Documentos Legales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),

                  _buildActionDocumentCard(
                    context,
                    title: 'Política de Privacidad',
                    description: 'Conoce en detalle cómo recopilamos, protegemos y utilizamos tus datos personales en la plataforma.',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => _showDocumentDialog(
                      context, 
                      'Política de Privacidad', 
                      '''Política de Privacidad de EduSafe

1. RECOPILACIÓN DE INFORMACIÓN
Recopilamos información personal necesaria para operar de manera óptima y segura el sistema de la institución educativa. Esto incluye: nombres y apellidos del apoderado, documento de identidad (DNI o documento de extranjería), fotografías para verificación biométrica del rostro y credenciales de contacto (correo electrónico, número de teléfono).

2. USO DE DATOS BIOMÉTRICOS
Toda la información biométrica recolectada se procesa exclusivamente para validar su identidad en el momento de retirar a un menor desde la institución en las vías de salida. EduSafe no vende, intercambia, ni distribuye a terceros los perfiles biométricos correspondientes a apoderados y familiares. 

3. USO DE HISTORIAL Y GEOLOCALIZACIÓN
Con la finalidad de llevar una auditoría segura, se guardan los historiales temporales cuando el QR es escaneado por el personal de seguridad (Guardias). Toda la trazabilidad queda guardada en bases de datos con encriptación avanzada para proteger integralmente la privacidad física de los involucrados.

4. CONSENTIMIENTO DE AUTORIZACIÓN A TERCEROS
En el evento que exista una autorización externa para delegar a un familiar o servicio de transporte privado la recogida de un estudiante, el emisor de la solicitud será co-responsable del compartir la base de privacidad correspondiente descrita al momento del registro externo.

5. PERMISOS EN DISPOSITIVOS
La plataforma requiere permisos del sistema sobre notificaciones locales, la cámara fotográfica y en su defecto de biometría local si se activan las funciones de Fast Login mediante Huella Dactilar o FaceID integrados en los terminales del propietario celular.''',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionDocumentCard(
                    context,
                    title: 'Términos de Servicio',
                    description: 'Revisa las reglas, condiciones y responsabilidades al utilizar nuestros servicios escolares.',
                    icon: Icons.gavel_rounded,
                    onTap: () => _showDocumentDialog(
                      context, 
                      'Términos de Servicio', 
                      '''Términos de Integración y Condiciones de Servicio de EduSafe

1. ACEPTACIÓN GENERAL
Al descargar, abrir e iniciar sesión dentro de la aplicación móvil EduSafe, usted indica automáticamente la aceptación íntegra de las condiciones detalladas en el mismo; así como el acuerdo total con las normativas locales orientadas al cuidado y resguardo de menores.

2. ESPECIFICACIÓN DE SEGURIDAD DEL USUARIO
Es estricta responsabilidad mantener con el grado de máximo nivel de resguardo confidencial las claves de acceso de cada individuo que ingresa a la plataforma. No existe la obligación por parte de terceros proveedores para dar soluciones en situaciones donde existió robo del celular, descuido de las claves de ingreso o entrega de los accesos biométricos de manera voluntaria. 

3. DEL USO DE LOS CÓDIGOS DINÁMICOS
El código de seguridad dinámico provisto en su interfaz principal rota por ciclos cerrados. Queda absolutamente vetado realizar copias estáticas u otro intento malicioso de evadir estos candados de prevención temporizada con propósito comercial o fraudulento.

4. CESE DE RESPONSABILIDAD DE ENTREGA
En el momento preciso de lectura del Código QR y posterior validación del rostro, la institución cede temporalmente su rol de guardián, y es el Padre/Madre/Tutor o Persona Autorizada de alta previa quien retoma automáticamente en cabalidad la total obligación tutelar y física respecto a salvaguardar al menor bajo su custodia natural.

5. LEGISLACIÓN VIGENTE
Cualquier controversia relacionada con estas plataformas o acuerdos deberá siempre llevarse e interpretarse a tenor y acuerdo de las normativas vigentes en jurisdicciones acordadas con los establecimientos educativos integrados dentro del programa.''',
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
=======
            const Icon(Icons.shield_rounded, size: 60, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text('Tu Seguridad es nuestra Prioridad', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('En EduSafe, utilizamos encriptación de grado militar y verificación biométrica para asegurar la seguridad de tu hijo.', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            _buildSecurityItem(
              Icons.lock_outline, 
              'Encriptación de Datos', 
              'Todos los datos personales y biométricos son cifrados y encriptados antes de ser almacenados.'
            ),
            _buildSecurityItem(
              Icons.visibility_off_outlined, 
              'Política de Privacidad', 
              'Nunca compartimos tu información personal con terceros sin tu consentimiento.'
            ),
            _buildSecurityItem(
              Icons.verified_user_outlined, 
              'Verificación Biométrica', 
              'La coincidencia facial se realiza localmente o a través de hashes seguros para proteger la identidad.'
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Leer Política de Privacidad Completa', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Términos de Servicio', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
>>>>>>> 6471b013fda23564e8df47e77326576b4c5aa486
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard({required IconData icon, required String title, required String description, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 6),
                Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionDocumentCard(BuildContext context, {required String title, required String description, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.deepPurple.shade100, width: 1.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.deepPurple.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.deepPurple, size: 30),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                  const SizedBox(height: 6),
                  Text(description, style: TextStyle(color: Colors.grey.shade700, fontSize: 14.5, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 20, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }
}

