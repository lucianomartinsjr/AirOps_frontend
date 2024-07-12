import 'package:flutter/material.dart';
import '../../widgets/custom_text_form_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordMatch = ValueNotifier<bool>(false);

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _changePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulação de lógica para alterar a senha
      bool success =
          true; // Esta variável deve ser definida com base no resultado da operação de alteração de senha

      if (success) {
        _showMessage('Senha alterada com sucesso', Colors.green);
        Navigator.pop(context); // Retorna à tela anterior
      } else {
        _showMessage('Erro ao alterar a senha', Colors.red);
      }
    }
  }

  void _validatePasswords() {
    _isPasswordMatch.value =
        newPasswordController.text == confirmPasswordController.text &&
            newPasswordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty;

    // Forçar validação dos campos para mostrar mensagens de erro
    _formKey.currentState?.validate();
  }

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_validatePasswords);
    confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    newPasswordController.removeListener(_validatePasswords);
    confirmPasswordController.removeListener(_validatePasswords);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100),
                  CustomTextFormField(
                    controller: newPasswordController,
                    labelText: 'Nova Senha',
                    readOnly: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua nova senha';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    labelText: 'Confirme a Nova Senha',
                    readOnly: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua nova senha';
                      }
                      if (value != newPasswordController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isPasswordMatch,
                    builder: (context, isPasswordMatch, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isPasswordMatch ? _changePassword : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPasswordMatch
                                ? const Color.fromARGB(255, 243, 33, 33)
                                : const Color.fromARGB(255, 200, 200, 200),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Alterar Senha',
                              style: TextStyle(fontSize: 18)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '←  Retornar ao Perfil',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
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
