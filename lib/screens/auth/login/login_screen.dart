import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api/api_service.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberEmail = useState(false);
    final isPasswordVisible = useState(false);
    final isLoading = useState(false);

    final emailError = useState<String?>(null); // Estado para armazenar o erro
    final passwordError = useState<String?>(null);

    useEffect(() {
      Future<void> initialize() async {
        const secureStorage = FlutterSecureStorage();
        await secureStorage.delete(key: 'isAdmin');
        await secureStorage.delete(key: 'hasToChangePassword');

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
      if (isLoading.value) return;
      isLoading.value = true;

      final email = emailController.text;
      final password = passwordController.text;

      // Validação dos campos
      bool isValid = true;
      if (email.isEmpty) {
        emailError.value = 'Por favor, insira seu email';
        isValid = false;
      } else {
        emailError.value = null;
      }

      if (password.isEmpty) {
        passwordError.value = 'Por favor, insira sua senha';
        isValid = false;
      } else {
        passwordError.value = null;
      }

      if (!isValid) {
        isLoading.value = false; // Adicione esta linha
        return;
      }

      if (rememberEmail.value) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('savedEmail', email);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('savedEmail');
      }

      final success = await ApiService().login(email, password);

      if (success) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/home-screen');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Login falhou. Verifique suas credenciais.')),
          );
        }
      }

      isLoading.value = false;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Image.asset('assets/images/logo.png', height: 200),
                        const SizedBox(height: 30),
                        const Text(
                          'Bem-vindo de volta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Faça login para continuar',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          errorText: emailError.value,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: passwordController,
                          label: 'Senha',
                          errorText: passwordError.value,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isPasswordVisible: isPasswordVisible,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
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
                                    inactiveTrackColor: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                                const Text(
                                  'Lembrar email',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/forgot-password');
                              },
                              child: const Text(
                                'Esqueceu a senha?',
                                style: TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
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
                              elevation: 2,
                            ),
                            child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não possui conta?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool isPassword = false,
    ValueNotifier<bool>? isPasswordVisible,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Colors.red,
      obscureText: isPassword && !(isPasswordVisible?.value ?? false),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2F2F2F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible!.value ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        errorText: errorText,
      ),
    );
  }
}