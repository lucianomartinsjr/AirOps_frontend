import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api/api_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';

// Importe a tela de registro
import '../register/register_screen.dart';

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

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

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
      body: Stack(
        children: [
          // Fundo animado com gradiente
          const AnimatedGradientBackground(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      FadeInDown(
                        duration: const Duration(milliseconds: 1000),
                        child:
                            Image.asset('assets/images/logo.png', height: 200),
                      ),
                      const SizedBox(height: 30),
                      FadeInLeft(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          'Bem-vindo de volta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInRight(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          'Faça login para continuar',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: _buildAnimatedTextField(
                          controller: emailController,
                          label: 'Email',
                          errorText: emailError.value,
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 200),
                        child: _buildAnimatedTextField(
                          controller: passwordController,
                          label: 'Senha',
                          errorText: passwordError.value,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isPasswordVisible: isPasswordVisible,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 400),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AnimatedSwitch(
                                  value: rememberEmail.value,
                                  onChanged: (value) {
                                    rememberEmail.value = value;
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Lembrar email',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/forgot-password');
                              },
                              child: const Text(
                                'Esqueceu a senha?',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 600),
                        child: AnimatedLoginButton(onPressed: handleLogin),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 800),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não possui conta?',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(_createRoute());
                              },
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading.value)
            FadeIn(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool isPassword = false,
    ValueNotifier<bool>? isPasswordVisible,
  }) {
    return ShakeWidget(
      child: TextField(
        controller: controller,
        cursorColor: Colors.red,
        obscureText: isPassword && !(isPasswordVisible?.value ?? false),
        style: const TextStyle(color: Colors.white),
        // Adicione esta linha para transformar o texto em minúsculas para o campo de email
        inputFormatters:
            label.toLowerCase() == 'email' ? [LowerCaseTextFormatter()] : null,
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
                    isPasswordVisible!.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          errorText: errorText,
        ),
      ),
    );
  }
}

class AnimatedGradientBackground extends HookWidget {
  const AnimatedGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 5),
    );

    useEffect(() {
      animationController.repeat(reverse: true);
      return null;
    }, []);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(const Color(0xFF222222), const Color(0xFF333333),
                    animationController.value)!,
                Color.lerp(const Color(0xFF333333), const Color(0xFF222222),
                    animationController.value)!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedLoginButton extends HookWidget {
  final VoidCallback onPressed;

  const AnimatedLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);

    return GestureDetector(
      onTapDown: (_) => isPressed.value = true,
      onTapUp: (_) => isPressed.value = false,
      onTapCancel: () => isPressed.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(isPressed.value ? 0.95 : 1.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
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
      ),
    );
  }
}

class AnimatedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AnimatedSwitch(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value ? Colors.red : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShakeWidget extends StatelessWidget {
  final Widget child;

  const ShakeWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShakeX(
      duration: const Duration(milliseconds: 100),
      from: 2,
      child: child,
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const RegisterScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
