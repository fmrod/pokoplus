import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:go_router/go_router.dart';
import '../models/data_models.dart';

class IngresarUsuarioScreen extends StatefulWidget {
  const IngresarUsuarioScreen({super.key});

  @override
  State<IngresarUsuarioScreen> createState() => _IngresarUsuarioScreenState();
}

class _IngresarUsuarioScreenState extends State<IngresarUsuarioScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _emailController.text.contains('@');
    });
  }

  // g.1) Función de Hashing
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final inputPassword = _passwordController.text;
    final hashedInput = _hashPassword(inputPassword);

    // g.2) Validación contra la lista
    final user = DataLists.findUserByEmail(email);

    if (user != null && user.password == hashedInput) {
      dev.log("Usuario autenticado correctamente");

      // h) Navegación por Rol
      if (user.userRole == "Padre") {
        context.push('/registro-actividad');
      } else {
        context.push('/ejecutar-actividad');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Credenciales incorrectas, volver a intentar"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // i) Botón de retorno
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // a) y b) Textos Superiores
            const Text(
              "Ingresar",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              "Completar sus credenciales",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            // c) Imagen Central
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset('assets/images/bienvenido.jpg', height: 180),
            ),

            // d) Entradas de Datos
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),

            // e) y f) Botón Dinámico
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _handleLogin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  "Ingresar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
