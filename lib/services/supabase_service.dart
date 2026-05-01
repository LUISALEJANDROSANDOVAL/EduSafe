import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

class SupabaseService {
  // Patrón Singleton para el servicio
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late SupabaseClient _client;
  SupabaseClient get client => _client;

  /// Inicializa la conexión con Supabase (debe llamarse en main.dart)
  Future<void> init() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  /// RF-01: Registro de Tutor
  /// Guarda metadatos y el hash (IPFS CID) de los documentos subidos previamente a Pinata
  Future<void> registerTutor({
    required String name,
    required String email,
    required String ipfsProfileHash,
    required String ipfsDocumentHash,
  }) async {
    await _client.from('tutors').insert({
      'name': name,
      'email': email,
      'profile_cid': ipfsProfileHash,
      'document_cid': ipfsDocumentHash,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// RF-01: Registro de Estudiante
  Future<void> registerStudent({
    required String tutorId,
    required String name,
    required String grade,
    required String ipfsProfileHash,
  }) async {
    await _client.from('students').insert({
      'tutor_id': tutorId,
      'name': name,
      'grade': grade,
      'profile_cid': ipfsProfileHash,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// RF-02: Guardar el Hash Biométrico para un Tutor / Tercero Autorizado
  Future<void> saveBiometricHash({
    required String personId,
    required String biometricHash,
  }) async {
    await _client.from('biometrics').insert({
      'person_id': personId,
      'biometric_hash': biometricHash,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// RF-03 & RF-04: Verificación de Código QR y Token
  /// Invoca una función RPC (Remote Procedure Call) en la base de datos de Supabase.
  Future<bool> verifyQrToken(String token, String studentId) async {
    try {
      final response = await _client.rpc('verify_qr_token', params: {
        'p_token': token,
        'p_student_id': studentId,
      });

      // Se asume que la función RPC retorna un booleano `true` si es válido
      return response == true;
    } catch (e) {
      print('Error verificando QR Token en RPC: \$e');
      return false;
    }
  }

  /// RF-04: Registrar el evento de recogida en el historial
  Future<void> logPickupEvent({
    required String studentId,
    required String personId,
    required bool isVerified,
    required double confidenceScore,
  }) async {
    await _client.from('pickup_logs').insert({
      'student_id': studentId,
      'person_id': personId,
      'is_verified': isVerified,
      'confidence_score': confidenceScore,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
