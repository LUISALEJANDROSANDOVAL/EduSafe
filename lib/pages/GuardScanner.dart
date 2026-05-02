import 'package:flutter/material.dart';
import 'GuardProfile.dart';
import 'IdentityValidation.dart';

class GuardScannerWidget extends StatefulWidget {
  const GuardScannerWidget({super.key});

  static String routeName = 'GuardScanner';

  @override
  State<GuardScannerWidget> createState() => _GuardScannerWidgetState();
}

class _GuardScannerWidgetState extends State<GuardScannerWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isScannerActive = true;

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isScannerActive = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isScannerActive
                      ? Colors.deepPurple
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: _isScannerActive
                          ? Colors.white
                          : Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Escáner',
                      style: TextStyle(
                        color: _isScannerActive
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isScannerActive = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isScannerActive
                      ? Colors.deepPurple
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: !_isScannerActive
                          ? Colors.white
                          : Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Historial',
                      style: TextStyle(
                        color: !_isScannerActive
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFrame() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated camera view (black background with a scan frame)
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // Scanning line animation simulation
          Positioned(
            top: 150,
            child: Container(width: 250, height: 2, color: Colors.greenAccent),
          ),
          // Bottom instruction
          Positioned(
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Alinea el código QR en el marco',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Ingreso Manual',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingresa el código de autorización o número de documento:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: 'Ej. DNI, Código...',
                  prefixIcon: const Icon(
                    Icons.badge_outlined,
                    color: Colors.deepPurple,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (idController.text.isNotEmpty) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IdentityValidationWidget(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Validar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricsCard(
    String title,
    String value,
    String subtitle,
    Color valueColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationCard(
    String studentName,
    String guardian,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  guardian,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Escáner de Guardia',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'SafeGuard School',
                        style: TextStyle(
                          color: Colors.deepPurple.shade300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GuardProfileWidget(),
                        ),
                      );
                    },
                    tooltip: 'Perfil del Guardia',
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildToggle(),
                    const SizedBox(height: 24),

                    if (_isScannerActive) ...[
                      _buildScannerFrame(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showManualEntryDialog(context),
                          icon: const Icon(
                            Icons.keyboard,
                            color: Colors.deepPurple,
                          ),
                          label: const Text(
                            'Ingreso Manual',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.deepPurple),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // History View (Metrics & Validations)
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricsCard(
                              'Hoy',
                              '142',
                              'Salida de Estudiantes',
                              Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMetricsCard(
                              'Pendientes',
                              '28',
                              'Restantes',
                              Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Validaciones Recientes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ver Todos',
                            style: TextStyle(
                              color: Colors.deepPurple.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildValidationCard(
                        'Mateo Garcia',
                        'Sofia Garcia (Madre)',
                        '14:22',
                      ),
                      _buildValidationCard(
                        'Lucia Torres',
                        'Carlos Mendez (Tío)',
                        '14:15',
                      ),
                      _buildValidationCard(
                        'Emma Wilson',
                        'David Wilson (Padre)',
                        '14:05',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
