import 'package:flutter/material.dart';
import 'config/env_config.dart';
import 'services/supabase_service.dart';
import 'pages/Login.dart'; // Importamos tu pantalla de Login real

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  await SupabaseService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edusafe',
      debugShowCheckedModeBanner: false, // Quitamos la etiqueta "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Apuntamos directamente al Widget de tu Login en vez del contador
      home: const LoginScreenWidget(),
    );
  }
}
