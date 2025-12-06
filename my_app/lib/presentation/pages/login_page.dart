import 'package:flutter/material.dart';
import '../../domain/usecases/user/authenticate_user.dart';
import '../../domain/usecases/user/user_result.dart';
import '../../domain/usecases/user/get_by_login.dart';

class LoginPage extends StatefulWidget {
  final AuthenticateUser authenticateUser;
  final GetByLogin getByLogin;

  const LoginPage({
    super.key,
    required this.authenticateUser,
    required this.getByLogin,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final UserResult result = await widget.authenticateUser(
      login: _loginController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      Navigator.of(context).pushNamed(
        '/profile', 
        arguments: result.user);
    } else {
      final message = result.errors.join('\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text(
                'Вход в аккаунт',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true, 
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onLoginPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Войти'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/registration',
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Создать аккаунт'),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}