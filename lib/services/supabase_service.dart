import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late SupabaseClient _client;
  SupabaseClient get client => _client;

  Future<void> init() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  // --- PERFILES ---
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    
    final response = await _client
        .from('perfiles')
        .select()
        .eq('id', user.id)
        .single();
    return response;
  }

  // --- ESTUDIANTES ---
  Future<List<Map<String, dynamic>>> getStudentsByTutor(String tutorId) async {
    final response = await _client
        .from('estudiantes')
        .select()
        .eq('tutor_id', tutorId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final response = await _client.from('estudiantes').select('*, perfiles(nombre_completo)');
    return List<Map<String, dynamic>>.from(response);
  }

  // --- TERCEROS ---
  Future<List<Map<String, dynamic>>> getAuthorizedThirdParties(String tutorId) async {
    final response = await _client
        .from('terceros')
        .select()
        .eq('tutor_id', tutorId)
        .eq('activo', true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> registerThirdParty({
    required String tutorId,
    required String name,
    required String ci,
    required String relation,
    required String biometricHash,
    String? photoCid,
    String? invitationId,
  }) async {
    await _client.from('terceros').insert({
      'tutor_id': tutorId,
      'nombre': name,
      'cedula_identidad': ci,
      'relacion': relation,
      'biometria_hash': biometricHash,
      'pinata_foto_cid': photoCid,
      'invitacion_id': invitationId,
    });
    
    if (invitationId != null) {
      await updateInvitationStatus(invitationId, 'Completado');
    }
  }

  // --- INVITACIONES ---
  Future<void> createInvitation({
    required String tutorId,
    required String estudianteId,
    required String email,
    required String token,
  }) async {
    await _client.from('invitaciones_terceros').insert({
      'tutor_id': tutorId,
      'estudiante_id': estudianteId,
      'correo_tercero': email,
      'token_seguridad': token,
      'estado': 'Pendiente',
    });
  }

  Future<List<Map<String, dynamic>>> getPendingInvitations(String tutorId) async {
    final response = await _client
        .from('invitaciones_terceros')
        .select()
        .eq('tutor_id', tutorId)
        .eq('estado', 'Pendiente');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateInvitationStatus(String id, String status) async {
    await _client.from('invitaciones_terceros').update({'estado': status}).eq('id', id);
  }

  // --- REGISTRO DE SALIDAS (LOGS) ---
  Future<List<Map<String, dynamic>>> getRecentPickupLogs(String tutorId) async {
    final response = await _client
        .from('registro_salidas')
        .select('*, estudiantes(nombre), terceros(nombre)')
        .eq('tutor_autorizador_id', tutorId)
        .order('fecha_hora', ascending: false)
        .limit(10);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> logPickup({
    required String studentId,
    required String tutorId,
    required String encargadoId,
    String? terceroId,
    required String qrToken,
    required String estado,
    String? evidenciaCid,
  }) async {
    await _client.from('registro_salidas').insert({
      'estudiante_id': studentId,
      'tutor_autorizador_id': tutorId,
      'tercero_id': terceroId,
      'encargado_id': encargadoId,
      'qr_token': qrToken,
      'estado': estado,
      'evidencia_salida_cid': evidenciaCid,
    });
  }

  // --- ESTADÍSTICAS ---
  Future<Map<String, int>> getTutorStats(String tutorId) async {
    final students = await _client.from('estudiantes').select('id').eq('tutor_id', tutorId);
    final thirdParties = await _client.from('terceros').select('id').eq('tutor_id', tutorId).eq('activo', true);
    final deliveries = await _client.from('registro_salidas').select('id').eq('tutor_autorizador_id', tutorId).eq('estado', 'Exitoso');

    return {
      'students': students.length,
      'thirdParties': thirdParties.length,
      'deliveries': deliveries.length,
    };
  }
}
