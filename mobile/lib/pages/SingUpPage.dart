import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/api/auth/api.auth.dart';
import 'package:mobile/api/conf/api.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  final ApiAuth apiAuth = ApiAuth(ApiClient());

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String messageError = '';
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if ([firstName, lastName, email, password].any((e) => e.isEmpty)) {
      setState(() => messageError = 'Debes completar todos los campos');
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() => messageError = 'Correo inválido');
      return;
    }

    setState(() {
      _isLoading = true;
      messageError = '';
    });

    try {
      final response = await apiAuth.register({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      });
      print('se logro $response');
      context.go('/login');
    } on DioException catch (e) {
      final msg = e.response?.data['message'].toString();

      setState(() {
        if(msg is String) {
          messageError = msg;
        } else {
          messageError = 'Password must be at least 4 characters long and include at least one lowercase letter, one uppercase letter, one number, and one special symbol.';
        }
      });
    }
    catch (e) {
      setState(() {
        messageError = 'Error al registrarse, intenta de nuevo';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
                hintText: 'ejemplo@correo.com',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: signUp,
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 12),
            if (messageError.isNotEmpty)
              Text(
                messageError,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}
