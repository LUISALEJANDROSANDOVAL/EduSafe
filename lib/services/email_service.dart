import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

class EmailService {
  static const String _url = 'https://api.emailjs.com/api/v1.0/email/send';

  Future<bool> enviarInvitacionEmail({
    required String toEmail,
    required String tutorName,
    required String studentName,
    required String invitationLink,
    String? tutorEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': EnvConfig.emailjsServiceId,
          'template_id': EnvConfig.emailjsTemplateId,
          'user_id': EnvConfig.emailjsPublicKey,
          'template_params': {
            'to_email': toEmail.trim(),
            'nombre_tutor': tutorName,
            'nombre_estudiante': studentName,
            'invitation_link': invitationLink,
            'correo_tutor': tutorEmail ?? '',
          },
        }),
      );

      if (response.statusCode == 200) {
        print("✅ EmailJS: Correo enviado con éxito.");
        return true;
      } else {
        print("❌ EmailJS Error (${response.statusCode}): ${response.body}");
        // Lanzamos una excepción con el cuerpo del error para que la UI pueda mostrarlo
        throw Exception("EmailJS Error: ${response.body}");
      }
    } catch (e) {
      print("🚨 EmailJS Excepción: $e");
      rethrow;
    }
  }
}
