import 'dart:convert';
import 'package:crypto/crypto.dart';

class BiometricService {
  /// Verifica si el dispositivo soporta autenticación biométrica
  Future<bool> isBiometricAvailable() async {
    // Retorno simulado temporal
    return true;
  }

  /// Autentica al usuario usando biometría y genera un hash si es exitoso.
  /// (BYPASS TEMPORAL: Retorna éxito automáticamente sin pedir local_auth)
  Future<String?> authenticateAndGenerateHash({String reason = 'Por favor autentícate para validar tu identidad'}) async {
    print("BIOMETRIA BYPASS ACTIVO: Simulando autenticación exitosa...");
    final String rawBiometricPayload = "biometric_template_simulation_payload_bypass"; 
    return generateHash(rawBiometricPayload);
  }

  /// RF-02: Aplica un hash criptográfico (SHA-256) al template biométrico
  String generateHash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
