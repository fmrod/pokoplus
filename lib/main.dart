import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/inicio.dart';
import 'screens/ingresar_usuario.dart';
import 'screens/registrar_usuario.dart';
import 'screens/registrar_actividad.dart';
import 'screens/ejecutar_actividad.dart';
import 'screens/reportar_actividades.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const InicioScreen()),
        GoRoute(
          path: '/ingreso',
          builder: (context, state) => const IngresarUsuarioScreen(),
        ),
        GoRoute(
          path: '/registro',
          builder: (context, state) => const RegistrarUsuarioScreen(),
        ),
        GoRoute(
          path: '/registro-actividad',
          builder: (context, state) => const RegistrarActividadScreen(),
        ),
        GoRoute(
          path: '/ejecutar-actividad',
          builder: (context, state) => const EjecutarActividadScreen(),
        ),
        GoRoute(
          path: '/reportes',
          builder: (context, state) => const ReportarActividadesScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'PokoPlus',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routerConfig: _router,
    );
  }
}
