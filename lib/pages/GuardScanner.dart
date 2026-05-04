import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'GuardProfile.dart';
import 'IdentityValidation.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class GuardScannerWidget extends StatefulWidget {
  const GuardScannerWidget({super.key});

  static String routeName = 'GuardScanner';

  @override
  State<GuardScannerWidget> createState() => _GuardScannerWidgetState();
}

class _GuardScannerWidgetState extends State<GuardScannerWidget> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isScannerActive = true;

  CameraController? _cameraController;
  late final BarcodeScanner _barcodeScanner;
  late final FaceDetector _faceDetector;
  
  bool _isProcessing = false;
  bool _faceDetected = false;
  String? _lastScannedCode;
  final _supabaseService = SupabaseService();
  
  // Dynamic metrics and history
  int _todayCount = 0;
  List<Map<String, dynamic>> _recentLogs = [];
  bool _isLoadingHistory = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _barcodeScanner = BarcodeScanner();
    _faceDetector = FaceDetector(options: FaceDetectorOptions(
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _initializeCamera();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    setState(() => _isLoadingHistory = true);
    try {
      final count = await _supabaseService.getTodayPickupsCount();
      final logs = await _supabaseService.getRecentPickupLogs();
      
      if (mounted) {
        setState(() {
          _todayCount = count;
          _recentLogs = logs;
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading guard history: $e");
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await _cameraController?.initialize();
    if (!mounted) return;
    setState(() {});

    _cameraController?.startImageStream(_processCameraImage);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || !_isScannerActive) return;
    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      // Escanear Código QR
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        final code = barcodes.first.displayValue;
        if (code != null && code != _lastScannedCode) {
          _lastScannedCode = code;
          _onQrDetected(code);
        }
      }

      // Escanear Rostro
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty && !_faceDetected) {
        setState(() {
          _faceDetected = true;
        });
      } else if (faces.isEmpty && _faceDetected) {
        setState(() {
          _faceDetected = false;
        });
      }
    } catch (e) {
      debugPrint("Error al procesar imagen: $e");
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21) || (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.isEmpty) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  void _onQrDetected(String code) {
    _cameraController?.stopImageStream();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IdentityValidationWidget()),
    ).then((_) {
      _lastScannedCode = null;
      if (_isScannerActive && mounted) {
        _cameraController?.startImageStream(_processCameraImage);
      }
    });
  }

  void _onFaceCapture() {
    _cameraController?.stopImageStream();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IdentityValidationWidget()),
    ).then((_) {
      if (_isScannerActive && mounted) {
        _cameraController?.startImageStream(_processCameraImage);
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    _faceDetector.close();
    _animationController.dispose();
    super.dispose();
  }

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
                onTap: () {
                setState(() => _isScannerActive = true);
                _cameraController?.startImageStream(_processCameraImage).catchError((e) => null);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isScannerActive ? Colors.deepPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner_rounded, color: _isScannerActive ? Colors.white : Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text('Escáner', style: TextStyle(color: _isScannerActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                setState(() => _isScannerActive = false);
                _cameraController?.stopImageStream().catchError((e) => null);
                _loadHistoryData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isScannerActive ? Colors.deepPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_rounded, color: !_isScannerActive ? Colors.white : Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text('Historial', style: TextStyle(color: !_isScannerActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
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
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // Camera Preview
            CameraPreview(_cameraController!),
            
            // Mask to dim background and show clear center
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scan frame border
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // Scanning line animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  top: 75 + (_animationController.value * 250),
                  child: Container(
                    width: 250,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

            // Face detected button overlay
            if (_faceDetected)
              Positioned(
                bottom: 80,
                child: ElevatedButton.icon(
                  onPressed: _onFaceCapture,
                  icon: const Icon(Icons.face_retouching_natural, color: Colors.white),
                  label: const Text('Capturar y Validar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              )
            else
              Positioned(
                bottom: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text('Alinea el código QR o rostro', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ingreso Manual', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa el código de autorización o número de documento:', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: 'Ej. DNI, Código...',
                  prefixIcon: const Icon(Icons.badge_outlined, color: Colors.deepPurple),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (idController.text.isNotEmpty) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IdentityValidationWidget()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Validar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricsCard(String title, String value, String subtitle, Color valueColor) {
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
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: valueColor)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildValidationCard(String studentName, String guardian, String time) {
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
            decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(guardian, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
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
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Escáner de Guardia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('SafeGuard School', style: TextStyle(color: Colors.deepPurple.shade300, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.deepPurple, size: 32),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GuardProfileWidget()),
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
                          icon: const Icon(Icons.keyboard, color: Colors.deepPurple),
                          label: const Text('Ingreso Manual', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.deepPurple),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ] else ...[
                      // History View
                      Row(
                        children: [
                          Expanded(child: _buildMetricsCard('Hoy', '$_todayCount', 'Salida de Estudiantes', Colors.deepPurple)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildMetricsCard('Alertas', _recentLogs.where((l) => l['estado'] == 'Alerta').length.toString(), 'Detectadas', Colors.redAccent)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Validaciones Recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: _loadHistoryData,
                            child: Text('Actualizar', style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isLoadingHistory)
                        const Center(child: CircularProgressIndicator())
                      else if (_recentLogs.isEmpty)
                        const Center(child: Text('No hay registros recientes'))
                      else
                        ..._recentLogs.take(5).map((log) {
                          final student = log['estudiantes'];
                          final thirdParty = log['terceros'];
                          final time = log['fecha_hora'] != null 
                              ? DateFormat('HH:mm').format(DateTime.parse(log['fecha_hora']).toLocal())
                              : '--:--';
                          
                          return _buildValidationCard(
                            student != null ? student['nombre'] : 'Estudiante',
                            thirdParty != null ? "${thirdParty['nombre']} (${thirdParty['relacion']})" : 'Tutor Principal',
                            time,
                          );
                        }).toList(),
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
