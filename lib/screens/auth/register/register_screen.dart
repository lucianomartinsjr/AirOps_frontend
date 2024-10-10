import 'package:flutter/material.dart';
import '../../../services/api/api_service.dart';
import 'email_page.dart';
import 'password_page.dart';
import 'profile_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedClass;
  List<String> selectedModalities = [];

  final ApiService apiService = ApiService();

  void _nextPage() {
    if (_pageController.page!.toInt() < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    FocusScope.of(context).unfocus();
    if (_pageController.page!.toInt() > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _submit() async {
    final email = emailController.text;
    final senha = passwordController.text;
    final nome = nameController.text;
    var apelido = nicknameController.text;
    final cidade = cityController.text;
    final telefone = phoneController.text;
    final classe = selectedClass;
    final modalidades = selectedModalities;

    if (apelido.isEmpty) {
      apelido = ' ';
    }

    if (email.isEmpty || senha.isEmpty || nome.isEmpty || classe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    try {
      final success = await apiService.register(
        email: email,
        password: senha,
        name: nome,
        nickname: apelido,
        city: cidade,
        phone: telefone,
        idClasseOperador: int.tryParse(classe),
        modalityIds: modalidades.map((e) => int.tryParse(e) ?? 0).toList(),
      );

      if (success['success'] == true) {
        Navigator.of(context).pushReplacementNamed('/home-screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Falha ao realizar o cadastro: ${success['message']}')),
        );
      }
    } catch (e) {
      debugPrint('Erro ao cadastrar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          EmailPage(emailController: emailController, onNext: _nextPage),
          PasswordPage(
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            onNext: _nextPage,
            onPrevious: _previousPage,
          ),
          ProfilePage(
            nameController: nameController,
            nicknameController: nicknameController,
            cityController: cityController,
            phoneController: phoneController,
            onClassChanged: (value) => setState(() => selectedClass = value),
            onModalityChanged: (value) =>
                setState(() => selectedModalities = value),
            onPrevious: _previousPage,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
}
