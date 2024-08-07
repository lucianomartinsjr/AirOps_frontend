import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberEmail = useState(false);

    useEffect(() {
      Future<void> initialize() async {
        const secureStorage = FlutterSecureStorage();
        await secureStorage.deleteAll();

        final prefs = await SharedPreferences.getInstance();
        final savedEmail = prefs.getString('savedEmail');
        if (savedEmail != null) {
          emailController.text = savedEmail;
          rememberEmail.value = true;
        }
      }

      initialize();
      return null;
    }, []);

    Future<void> handleLogin() async {
      final email = emailController.text;
      final password = passwordController.text;

      if (rememberEmail.value) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('savedEmail', email);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('savedEmail');
      }

      final success = await ApiService().login(email, password);

      if (success) {
        Navigator.of(context).pushReplacementNamed('/home-screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login falhou. Verifique suas credenciais.')),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/images/logo.png', height: 250),
                  const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          cursorColor: Colors.red,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: const Color(0xFF2F2F2F),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          cursorColor: Colors.red,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: const Color(0xFF2F2F2F),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Lembrar email',
                              style: TextStyle(color: Colors.white),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: rememberEmail.value,
                                onChanged: (value) {
                                  rememberEmail.value = value;
                                },
                                activeColor: Colors.red,
                                activeTrackColor: Colors.red.withOpacity(0.5),
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor:
                                    Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Entrar',
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text(
                      'Não possui conta? \nClique aqui para se cadastrar.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/forgot-password');
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
