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

  // --- AUTENTICACIÓN ---
  Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
    // --- MOCK DE PRUEBA (Bypass temporal para desarrollo) ---
    if (email.endsWith('@test.com')) {
      _currentUserProfile = {
        'id': 'f8b04eef-3e5d-40b6-b494-f49c99d8bd81', 
        'correo': email,
        'nombre_completo': 'Carlos Mendez (SafeGuard)',
        'rol': 'Tutor',
      };
      return _currentUserProfile!;
    }

    final response = await _client.from('perfiles').select().eq('correo', email).maybeSingle();
    if (response == null) throw Exception('Correo no registrado.');
    
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();
    if (response['password_hash'] != hashedPassword && response['password_hash'] != password) {
      throw Exception('Contraseña incorrecta.');
    }

    _currentUserProfile = response;
    return response;
  }

  Future<void> signOut() async {
    _currentUserProfile = null;
    try { await _client.auth.signOut(); } catch (_) {}
  }

  // --- PERFILES ---
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    if (_currentUserProfile != null) return _currentUserProfile;
    
    final user = _client.auth.currentUser;
    if (user != null) {
      final response = await _client.from('perfiles').select().eq('id', user.id).maybeSingle();
      _currentUserProfile = response;
    }
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

    if (_currentUserProfile != null && _currentUserProfile!['id'] == id) {
      _currentUserProfile = {..._currentUserProfile!, ...updates};
    }
  }

  // --- ESTUDIANTES ---
  Future<List<Map<String, dynamic>>> getStudentsByTutor(String tutorId) async {
    final response = await _client.from('estudiantes').select().eq('tutor_id', tutorId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final response = await _client.from('estudiantes').select();
    return List<Map<String, dynamic>>.from(response);
  }

  // --- TERCEROS ---
  Future<List<Map<String, dynamic>>> getAuthorizedThirdParties(String tutorId) async {
    final response = await _client.from('terceros').select().eq('tutor_id', tutorId).eq('activo', true);
    return List<Map<String, dynamic>>.from(response);
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
    final response = await _client.from('invitaciones_terceros').select().eq('tutor_id', tutorId).eq('estado', 'Pendiente');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateInvitationStatus(String id, String status) async {
    await _client.from('invitaciones_terceros').update({'estado': status}).eq('id', id);
  }

  // --- REGISTRO DE SALIDAS (HISTORIAL) ---
  Future<List<Map<String, dynamic>>> getRecentPickupLogs(String tutorId) async {
    try {
      final response = await _client
          .from('registro_salidas')
          .select('*, estudiantes(nombre, curso), terceros(nombre, relacion), perfiles!encargado_id(nombre_completo)')
          .eq('tutor_id', tutorId)
          .order('fecha_hora', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      final basic = await _client.from('registro_salidas').select('*').eq('tutor_id', tutorId);
      return List<Map<String, dynamic>>.from(basic);
    }
  }

  Future<int> getTodayPickupsCount(String tutorId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
    final response = await _client.from('registro_salidas').select('id').eq('tutor_id', tutorId).gte('fecha_hora', startOfDay);
    return (response as List).length;
  }

  // --- NOTIFICACIONES ---
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    final response = await _client.from('notificaciones').select().eq('usuario_id', userId).order('creada_en', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _client.from('notificaciones').update({'leida': true}).eq('id', notificationId);
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    await _client.from('notificaciones').update({'leida': true}).eq('usuario_id', userId);
  }

  // --- ESTADÍSTICAS ---
  Future<Map<String, int>> getTutorStats(String tutorId) async {
    try {
      final students = await _client.from('estudiantes').select('id').eq('tutor_id', tutorId);
      final thirdParties = await _client.from('terceros').select('id').eq('tutor_id', tutorId).eq('activo', true);
      final deliveries = await _client.from('registro_salidas').select('id').eq('tutor_id', tutorId).eq('estado', 'Exitoso');
      return {
        'students': (students as List).length,
        'thirdParties': (thirdParties as List).length,
        'deliveries': (deliveries as List).length,
      };
    } catch (_) {
      return {'students': 0, 'thirdParties': 0, 'deliveries': 0};
    }
  }

  // --- GUARDIAS ---
  Future<List<Map<String, dynamic>>> getAllGuards() async {
    final response = await _client.from('perfiles').select().eq('rol', 'Encargado');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addGuard({required String nombreCompleto, required String idEmpleado, required String turno}) async {
    final correo = '${idEmpleado.toLowerCase()}@colegio.com';
    await _client.from('perfiles').insert({
      'nombre_completo': nombreCompleto,
      'cedula_identidad': idEmpleado,
      'correo': correo,
      'rol': 'Encargado',
      'password_hash': idEmpleado,
    });
  }

  Future<void> updateGuardStatus({
    required String id,
    String? turno,
    String? estado,
  }) async {
    final Map<String, dynamic> updates = {};
    if (turno != null) updates['turno'] = turno;
    // Intentaremos actualizar estado también, capturando el error si la columna no existe
    if (estado != null) updates['estado'] = estado; 

    if (updates.isNotEmpty) {
      try {
        await _client.from('perfiles').update(updates).eq('id', id);
      } catch (e) {
        print('Error actualizando estado/turno: \$e');
        // Fallback: Si da error porque las columnas no existen, lo ignoramos para que no rompa la UI
        // En producción deberías añadir las columnas 'turno' y 'estado' a la tabla 'perfiles'
      }
    }
  }

  // --- REGISTRO DE TERCEROS (DESDE FORMULARIO WEB) ---
  Future<void> registerThirdParty({
    required String tutorId,
    required String name,
    required String ci,
    required String relation,
    required String biometricHash,
    required String photoCid,
    String? invitationId,
  }) async {
    // 1. Insertar el tercero en la tabla 'terceros'
    final response = await _client.from('terceros').insert({
      'tutor_id': tutorId,
      'nombre': name,
      'cedula_identidad': ci,
      'relacion': relation,
      'biometria_hash': biometricHash,
      'pinata_foto_cid': photoCid,
      'activo': true,
    }).select().single();

    // 2. Si hay una invitación, marcarla como 'Completada'
    if (invitationId != null) {
      await _client.from('invitaciones_terceros').update({
        'estado': 'Completada',
      }).eq('token_seguridad', invitationId);
    }
  }
}

