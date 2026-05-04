import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get pinataApiKey => dotenv.env['PINATA_API_KEY'] ?? '';
  static String get pinataSecretApiKey => dotenv.env['PINATA_SECRET_API_KEY'] ?? '';
  static String get pinataJwt => dotenv.env['PINATA_JWT'] ?? '';
  static String get emailjsServiceId => dotenv.env['EMAILJS_SERVICE_ID'] ?? '';
  static String get emailjsTemplateId => dotenv.env['EMAILJS_TEMPLATE_ID'] ?? '';
  static String get emailjsPublicKey => dotenv.env['EMAILJS_PUBLIC_KEY'] ?? '';
  static String get emailjsPrivateKey => dotenv.env['EMAILJS_PRIVATE_KEY'] ?? '';

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}
