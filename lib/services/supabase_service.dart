import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
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
    final response = await _client.from('perfiles').select().eq('correo', email).maybeSingle();

    if (response == null) {
      throw Exception('El correo ingresado no se encuentra registrado.');
    }
    
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    if (response['password_hash'] != hashedPassword && response['password_hash'] != password) {
      throw Exception('La contraseña es incorrecta.');
    }

    _currentUserProfile = response;
    return response;
  }

  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String ci,
    required String role,
  }) async {
    final responseCheck = await _client.from('perfiles').select().eq('correo', email).maybeSingle();
    if (responseCheck != null) {
      throw Exception('Este correo ya está registrado.');
    }

    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    final response = await _client.from('perfiles').insert({
      'nombre_completo': fullName,
      'correo': email,
      'cedula_identidad': ci,
      'password_hash': hashedPassword,
      'rol': role,
    }).select().single();

    return response;
  }

  Future<void> updatePassword({
    required String email,
    required String ci,
    required String newPassword,
  }) async {
    final responseCheck = await _client.from('perfiles').select().eq('correo', email).eq('cedula_identidad', ci).maybeSingle();
    if (responseCheck == null) {
      throw Exception('El correo o la Cédula de Identidad no coinciden.');
    }

    final bytes = utf8.encode(newPassword);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    final updateResponse = await _client.from('perfiles').update({'password_hash': hashedPassword}).eq('id', responseCheck['id']).select();
    
    if (updateResponse.isEmpty) {
      throw Exception('No se pudo actualizar la contraseña.');
    }

    await _client.from('notificaciones').insert({
      'usuario_id': responseCheck['id'],
      'titulo': 'Contraseña Actualizada',
      'mensaje': 'Has restablecido tu contraseña exitosamente.',
      'tipo': 'Seguridad',
      'leida': false,
    });
  }

  Future<void> resetPassword(String email) async {
    final response = await _client.from('perfiles').select().eq('correo', email).maybeSingle();
    if (response == null) throw Exception('El correo no está registrado.');
    
    await _client.from('notificaciones').insert({
      'usuario_id': response['id'],
      'titulo': 'Recuperación de Contraseña',
      'mensaje': 'Se ha solicitado un enlace para restablecer tu contraseña.',
      'leida': false,
    });
  }

  Future<Map<String, dynamic>> signInWithBiometrics(String biometricHash) async {
    final response = await _client.from('perfiles').select().eq('biometria_hash', biometricHash).maybeSingle();
    if (response == null) {
      throw Exception('No hay una cuenta vinculada a esta biometría.');
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
    final response = await _client.from('estudiantes').select('*, perfiles(nombre_completo)');
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
  Future<List<Map<String, dynamic>>> getRecentPickupLogs([String? tutorId]) async {
    try {
      var logsQuery = _client.from('registro_salidas').select('*');
      if (tutorId != null) logsQuery = logsQuery.eq('tutor_autorizador_id', tutorId);
      final logsRes = await logsQuery.order('fecha_hora', ascending: false).limit(50);
      final List<Map<String, dynamic>> logs = List<Map<String, dynamic>>.from(logsRes);

      if (logs.isEmpty) return [];

      final studentIds = logs.map((l) => l['estudiante_id']).where((id) => id != null).toList();
      final guardIds = logs.map((l) => l['encargado_id']).where((id) => id != null).toList();
      final terceroIds = logs.map((l) => l['tercero_id']).where((id) => id != null).toList();

      final studentsRes = await _client.from('estudiantes').select('id, nombre, curso').inFilter('id', studentIds);
      final studentsMap = {for (var s in studentsRes) s['id'].toString(): s};

      final perfilesRes = await _client.from('perfiles').select('id, nombre_completo').inFilter('id', guardIds);
      final perfilesMap = {for (var p in perfilesRes) p['id'].toString(): p};

      final tercerosRes = await _client.from('terceros').select('id, nombre, relacion').inFilter('id', terceroIds);
      final tercerosMap = {for (var t in tercerosRes) t['id'].toString(): t};

      return logs.map((log) {
        return {
          ...log,
          'estudiantes': studentsMap[log['estudiante_id']?.toString()],
          'guardia': perfilesMap[log['encargado_id']?.toString()],
          'terceros': tercerosMap[log['tercero_id']?.toString()],
        };
      }).toList();
    } catch (e) {
      debugPrint("🚨 Error in getRecentPickupLogs: $e");
      return [];
    }
  }

  Future<int> getTodayPickupsCount([String? tutorId]) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
    
    var query = _client.from('registro_salidas').select('id').gte('fecha_hora', startOfDay);
    if (tutorId != null) {
      query = query.eq('tutor_autorizador_id', tutorId);
    }
    
    final response = await query;
    return (response as List).length;
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
    final students = await _client.from('estudiantes').select('id').eq('tutor_id', tutorId);
    final thirdParties = await _client.from('terceros').select('id').eq('tutor_id', tutorId).eq('activo', true);
    final deliveries = await _client.from('registro_salidas').select('id').eq('tutor_autorizador_id', tutorId).eq('estado', 'Exitoso');

    return {
      'students': students.length,
      'thirdParties': thirdParties.length,
      'deliveries': deliveries.length,
    };
  }

  // --- ADMIN & GUARDIAS ---
  Future<List<Map<String, dynamic>>> getAllGuards() async {
    final response = await _client.from('perfiles').select().eq('rol', 'Encargado');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addGuard({
    required String nombreCompleto,
    required String idEmpleado,
    required String turno,
  }) async {
    final hashedPassword = sha256.convert(utf8.encode(idEmpleado)).toString();
    try {
      await _client.from('perfiles').insert({
        'nombre_completo': nombreCompleto,
        'cedula_identidad': idEmpleado,
        'rol': 'Encargado',
        'correo': 'guardia.$idEmpleado@edusafe.com',
        'password_hash': hashedPassword,
        'turno': turno,
        'estado': 'Activo',
      });
    } catch (_) {
      await _client.from('perfiles').insert({
        'nombre_completo': nombreCompleto,
        'cedula_identidad': idEmpleado,
        'rol': 'Encargado',
        'correo': 'guardia.$idEmpleado@edusafe.com',
        'password_hash': hashedPassword,
      });
    }
  }

  Future<void> updateGuardStatus({
    required String id,
    required String turno,
    required String estado,
  }) async {
    try {
      await _client.from('perfiles').update({
        'turno': turno,
        'estado': estado,
      }).eq('id', id);
    } catch (_) {}
  }

  // --- REGISTRO DE TERCEROS ---
  Future<void> registerThirdParty({
    required String tutorId,
    required String name,
    required String ci,
    required String relation,
    required String biometricHash,
    required String photoCid,
    String? invitationId,
  }) async {
    await _client.from('terceros').insert({
      'tutor_id': tutorId,
      'nombre': name,
      'cedula_identidad': ci,
      'relacion': relation,
      'biometria_hash': biometricHash,
      'pinata_foto_cid': photoCid,
      'activo': true,
    }).select().single();

    if (invitationId != null) {
      await _client.from('invitaciones_terceros').update({'estado': 'Completada'}).eq('id', invitationId);
    }
  }
}
