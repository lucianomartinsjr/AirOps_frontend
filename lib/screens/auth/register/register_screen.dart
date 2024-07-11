import 'package:flutter/material.dart';
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

  void _nextPage() {
    if (_pageController.page!.toInt() < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    if (_pageController.page!.toInt() > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _submit() {
    // Combine all the collected data and send to the API
    final email = emailController.text;
    final senha = passwordController.text;
    final nome = nameController.text;
    final apelido = nicknameController.text;
    final cidade = cityController.text;
    final telefone = phoneController.text;
    final classe = selectedClass;
    final modalidades = selectedModalities;

    // Call your API service to register the user
    print(
        "Email: $email, Senha: $senha, Nome: $nome, Apelido: $apelido, Cidade: $cidade, Telefone: $telefone, Classe: $classe, Modalidades: $modalidades");
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
