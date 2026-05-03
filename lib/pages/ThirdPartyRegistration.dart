import 'package:flutter/material.dart';

class ThirdPartyRegistrationWidget extends StatefulWidget {
  const ThirdPartyRegistrationWidget({super.key});

  static String routeName = 'ThirdPartyRegistration';

  @override
  State<ThirdPartyRegistrationWidget> createState() => _ThirdPartyRegistrationWidgetState();
}

class _ThirdPartyRegistrationWidgetState extends State<ThirdPartyRegistrationWidget> {
  int _currentStep = 0;
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (index) {
        bool isActive = _currentStep >= index;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.deepPurple : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Información Personal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Por favor, proporciona tus datos legales tal como aparecen en tu identificación.', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Nombre Completo',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _idController,
          decoration: InputDecoration(
            labelText: 'Número de Identificación (CI)',
            prefixIcon: const Icon(Icons.badge_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Número de Teléfono',
            prefixIcon: const Icon(Icons.phone_android_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Verificación de Seguridad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Necesitamos una foto clara de tu rostro para el control de la puerta de seguridad.', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepPurple, width: 2, style: BorderStyle.solid),
            ),
            child: const Icon(Icons.face_retouching_natural_rounded, size: 80, color: Colors.deepPurple),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
            label: const Text('Tomar Foto de Rostro', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Carga de Documentos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Sube una foto clara de tu Documento de Identificación.', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.contact_page_rounded, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('Frente de tu ID', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Clic para subir', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro EduSafe', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 32),
              Expanded(
                child: _currentStep == 0 
                  ? _buildPersonalInfo() 
                  : _currentStep == 1 
                    ? _buildBiometrics() 
                    : _buildDocuments(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Anterior'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        } else {
                          // Success
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Registro Completo'),
                              content: const Text('Tu identidad ha sido verificada. Ahora estás autorizado para la recogida.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Finalizar')),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _currentStep < 2 ? 'Siguiente' : 'Completar Registro',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
