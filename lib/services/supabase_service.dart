import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
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

  Map<String, dynamic>? _currentUserProfile;

  // --- AUTENTICACIÓN PERSONALIZADA ---
  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    // Buscar usuario por correo en la tabla perfiles
    final response = await _client
        .from('perfiles')
        .select()
        .eq('correo', email)
        .maybeSingle();

    if (response == null) {
      throw Exception('El correo ingresado no se encuentra registrado.');
    }
    
    // Hashear la contraseña ingresada con SHA-256
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    // Comparar contraseña (soporta texto plano como fallback temporal por si creaste registros manuales sin hash)
    if (response['password_hash'] != hashedPassword && response['password_hash'] != password) {
      throw Exception('La contraseña es incorrecta.');
    }

    // Guardar sesión en memoria
    _currentUserProfile = response;
    return response;
  }

  Future<void> signOut() async {
    // Limpiar la sesión en memoria y también intentar cerrar Supabase Auth por seguridad
    _currentUserProfile = null;
    try { await _client.auth.signOut(); } catch (_) {}
  }

  // --- PERFILES ---
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    return _currentUserProfile;
  }

  Future<void> updateUserProfile({
    required String id,
    String? nombreCompleto,
    String? cedulaIdentidad,
    String? telefono,
    String? correo,
  }) async {
    final Map<String, dynamic> updates = {};
    if (nombreCompleto != null) updates['nombre_completo'] = nombreCompleto;
    if (cedulaIdentidad != null) updates['cedula_identidad'] = cedulaIdentidad;
    if (telefono != null) updates['telefono'] = telefono;
    if (correo != null) updates['correo'] = correo;

    if (updates.isEmpty) return;

    await _client.from('perfiles').update(updates).eq('id', id);

    // Actualizar cache local
    if (_currentUserProfile != null && _currentUserProfile!['id'] == id) {
      _currentUserProfile = {
        ..._currentUserProfile!,
        ...updates,
      };
    }
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
    final response = await _client.from('estudiantes').select();
    final tutors = await _client.from('perfiles').select('id, nombre_completo').eq('rol', 'Tutor');
    
    List<Map<String, dynamic>> students = List<Map<String, dynamic>>.from(response);
    List<Map<String, dynamic>> loadedTutors = List<Map<String, dynamic>>.from(tutors);

    for (var student in students) {
      if (student['tutor_id'] != null) {
        final tutor = loadedTutors.firstWhere(
          (t) => t['id'] == student['tutor_id'],
          orElse: () => <String, dynamic>{},
        );
        if (tutor.isNotEmpty) {
          student['perfiles'] = {'nombre_completo': tutor['nombre_completo']};
        }
      }
    }
    return students;
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
