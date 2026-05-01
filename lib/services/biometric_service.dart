import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Verifica si el dispositivo soporta autenticación biométrica
  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  /// Autentica al usuario usando biometría y genera un hash si es exitoso.
  /// En una implementación real más compleja, se obtiene un 'template' y se hashea.
  /// Aquí simulamos el flujo de hash a partir de un identificador único local o un payload de éxito.
  Future<String?> authenticateAndGenerateHash({String reason = 'Por favor autentícate para validar tu identidad'}) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // En una implementación FIDO2 o más avanzada, esto sería un token o un template raw.
        // Por ahora, simulamos un payload seguro en base al dispositivo/timestamp o una llave estática temporal.
        final String rawBiometricPayload = "biometric_template_simulation_payload"; 
        
        // RF-02: Generamos un hash del template biométrico
        return generateHash(rawBiometricPayload);
      }
    } catch (e) {
      print("Error en biometría: \$e");
    }
    return null;
  }

  /// RF-02: Aplica un hash criptográfico (SHA-256) al template biométrico
  String generateHash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
