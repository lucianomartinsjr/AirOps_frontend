import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../services/api/api_service.dart';
import 'password_reset_confirmation.dart';

class ForgotPasswordScreen extends HookWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final apiService = ApiService();

    Future<void> handleForgotPassword() async {
      final email = emailController.text;

      // Exibe o diálogo de confirmação imediatamente
      final shouldSendEmail = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2F2F2F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Row(
              children: [
                Text(
                  'Confirmação',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.question_mark,
                    color: Color.fromARGB(255, 255, 255, 255)),
                SizedBox(width: 10),
              ],
            ),
            content: Text(
              'Deseja realmente enviar uma nova senha para o email $email?',
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Fecha o diálogo e retorna false
                },
                style: TextButton.styleFrom(
                  // backgroundColor: Colors.red
                  //     .withOpacity(0.1), // Fundo com leve transparência
                  foregroundColor: Colors.red, // Cor do texto
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Espaçamento
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Bordas arredondadas
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16, // Tamanho do texto
                    fontWeight: FontWeight.bold, // Negrito para destaque
                  ),
                ),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Fecha o diálogo e retorna true
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green
                      .withOpacity(0.1), // Fundo com leve transparência
                  foregroundColor: Colors.green, // Cor do texto
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Espaçamento
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Bordas arredondadas
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16, // Tamanho do texto
                    fontWeight: FontWeight.bold, // Negrito para destaque
                  ),
                ),
                child: const Text('Enviar'),
              ),
            ],
          );
        },
      );

      if (shouldSendEmail == true) {
        // Verifica se o email é válido
        final isEmailValid = await apiService.checkEmail(email);

        if (!isEmailValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text('O email fornecido não está registrado.'),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Envia o email de recuperação de senha
        final response = await apiService.forgotPassword(email);

        if (!response) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Falha ao enviar email de recuperação.'),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Você pode adicionar uma ação após o envio bem-sucedido, como uma navegação direta
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PasswordResetConfirmationScreen(),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF222222), // Cor de fundo #222222
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
                  Image.asset('assets/images/logo.png', height: 250),
                  const SizedBox(height: 20),
                  const Text(
                    'Recuperar Senha',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: handleForgotPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Enviar',
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('/login_screen');
                            FocusScope.of(context).unfocus();
                          },
                          child: const Text(
                            '← Retornar ao login',
                            style: TextStyle(color: Colors.white),
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
    );
  }
}
