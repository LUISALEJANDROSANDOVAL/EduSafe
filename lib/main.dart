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
    // Detectar si la URL contiene la ruta de registro de tercero
    // Esto es necesario porque en Flutter Web con hash strategy,
    // los query params pueden interferir con el route matching
    final uri = Uri.base;
    String initialRoute = '/';
    
    // Revisar si el fragmento (después del #) contiene registro-tercero
    if (uri.fragment.contains('registro-tercero')) {
      initialRoute = '/registro-tercero';
    }

    return MaterialApp(
      title: 'SafeGuard School',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        final routeName = settings.name ?? '';
        
        // Si la ruta contiene registro-tercero (con o sin parámetros)
        if (routeName.contains('registro-tercero')) {
          return MaterialPageRoute(
            builder: (context) => const TerceroWebFormPage(),
            settings: settings,
          );
        }
        
        // Rutas normales
        switch (routeName) {
          case '/dashboard':
            return MaterialPageRoute(
              builder: (context) => const ParentDashboardWidget(),
            );
          case '/':
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreenWidget(),
            );
        }
      },
    );
  }
}
