import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:go_router/go_router.dart';
import '../models/data_models.dart';

class RegistrarUsuarioScreen extends StatefulWidget {
  const RegistrarUsuarioScreen({super.key});

  @override
  State<RegistrarUsuarioScreen> createState() => _RegistrarUsuarioScreenState();
}

class _RegistrarUsuarioScreenState extends State<RegistrarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // Estados de UI
  String _selectedRole = 'Hijo';
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Escuchadores para habilitar el botón dinámicamente
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passController.addListener(_validateForm);
    _confirmPassController.addListener(_validateForm);
  }

  // e) Función que valida campos y habilita el botón
  void _validateForm() {
    final bool allFilled =
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passController.text.isNotEmpty &&
        _confirmPassController.text.isNotEmpty;

    final bool passwordsMatch =
        _passController.text == _confirmPassController.text;

    setState(() {
      _isButtonEnabled = allFilled && passwordsMatch;
    });
  }

  // f.1) Función de Hashing
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  void _handleCreateUser() {
    if (_formKey.currentState!.validate()) {
      // f.1) Guardar datos
      final newUser = User(
        idUser: DataLists.usersList.length + 1,
        userRole: _selectedRole,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _hashPassword(_passController.text),
        status: "Activo",
        registrationDate: DateTime.now(),
      );

      DataLists.usersList.add(newUser);
      dev.log("Usuario registrado correctamente");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario registrado con éxito")),
      );

      // f.2) Cargar pantalla de Ingreso
      context.push('/ingreso');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // g) Botón de retorno a Inicio
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // a) y b) Textos Superiores
              const Text(
                "Registrarse",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                "Completar sus datos",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // c) Datos de entrada
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre completo",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Este campo es obligatorio" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty || !v.contains('@')
                    ? "Ingrese un correo válido"
                    : null,
              ),
              const SizedBox(height: 15),

              // Combo Box de Rol
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['Padre', 'Hijo']
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedRole = val!),
                decoration: const InputDecoration(
                  labelText: "Rol",
                  prefixIcon: Icon(Icons.people),
                ),
              ),
              const SizedBox(height: 15),

              // Contraseña
              TextFormField(
                controller: _passController,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Contraseña obligatoria" : null,
              ),
              const SizedBox(height: 15),

              // Confirmar Contraseña
              TextFormField(
                controller: _confirmPassController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Confirma contraseña",
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                // e) Validación de igualdad
                validator: (v) =>
                    v != _passController.text ? "Contraseñas diferentes" : null,
              ),
              const SizedBox(height: 40),

              // d) Botón Crear
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _handleCreateUser : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: const Text(
                    "Crear",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }
}
