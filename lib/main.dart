import 'package:flutter/material.dart';
import 'config/env_config.dart';
import 'services/supabase_service.dart';
import 'pages/Login.dart';
import 'pages/TerceroWebFormPage.dart';
import 'pages/ParentDashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await EnvConfig.init();
    await SupabaseService().init();
  } catch (e) {
    debugPrint("Error inicializando servicios: $e");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeGuard School',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreenWidget(),
        '/dashboard': (context) => const ParentDashboardWidget(),
        '/registro-tercero': (context) => const TerceroWebFormPage(),
      },
    );
  }
}
