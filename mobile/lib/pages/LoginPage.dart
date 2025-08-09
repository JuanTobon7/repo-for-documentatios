import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/api/auth/api.auth.dart';
import 'package:mobile/api/conf/api.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  String email = '';
  String password = '';
  String messageError = '';
  ApiAuth apiAuth = ApiAuth(ApiClient());

  Future<void> loginFun() async {

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        messageError = 'Debes completar todos los campos';
      });
      return;
    }

    try {
      final data = {
        "email": email,
        "password": password,
      };
      final response = await apiAuth.login(data);
      print(response);
      context.go('/');

    } catch (e) {
      setState(() {
        messageError = 'Error al iniciar sesión: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Center(
        child:  Padding(
        padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextField(
                onChanged: (text) => email = text,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: jhondoe@example.com',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (text) => password = text,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: SuperSecretPassword',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await loginFun();
                },
                child: const Text('Iniciar Sesión'),
              ),
              TextButton(onPressed: ()=>context.go('/sign-up'),
                  child: Text('Registrarse',style: TextStyle(fontSize: 12),)
              ),
              Text(
                messageError,
                style: TextStyle(color: Colors.red, fontSize: 13),
              )
            ],
          ),
        ),
      )
    );
  }
}
