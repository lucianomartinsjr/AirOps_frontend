import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../services/api/api_service.dart';
import '../../widgets/form_fields/password_strength_indicator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
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

  Future<void> _changePassword(ApiService apiService) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        bool success =
            await apiService.changePassword(newPasswordController.text);
        if (!mounted) return; // Verifica se o widget ainda está montado
        if (success) {
          _showMessage('Senha alterada com sucesso', Colors.green);
          Navigator.pop(context);
        } else {
          _showMessage('Erro ao alterar a senha', Colors.red);
        }
      } catch (error) {
        if (!mounted) return; // Verifica novamente se o widget está montado
        _showMessage('Erro ao se conectar ao servidor: $error', Colors.red);
      }
    }
  }

  void _validatePasswords() {
    _isPasswordMatch.value =
        newPasswordController.text == confirmPasswordController.text &&
            newPasswordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty;
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
    final apiService = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        elevation: 0, // Remove a sombra da AppBar
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Crie uma nova senha forte',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sua nova senha deve ter pelo menos 6 caracteres e é ideal que inclua uma combinação de números, letras e caracteres especiais.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    CustomTextFormField(
                      controller: newPasswordController,
                      labelText: 'Nova Senha',
                      readOnly: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua nova senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
                    PasswordStrengthIndicator(
                        controller: newPasswordController),
                    const SizedBox(height: 40),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isPasswordMatch,
                      builder: (context, isPasswordMatch, child) {
                        return ElevatedButton(
                          onPressed: isPasswordMatch
                              ? () => _changePassword(apiService)
                              : null, // Desabilita o botão se as senhas não coincidirem
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors
                                .white, // Cor do texto ajustada para branco
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // Define a cor e o estilo do botão desabilitado
                            disabledBackgroundColor:
                                Colors.redAccent.withOpacity(0.5),
                            disabledForegroundColor:
                                Colors.white.withOpacity(0.7),
                          ),
                          child: const Text(
                            'Alterar Senha',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '←  Retornar ao Perfil',
                        style: TextStyle(
                          color: Color.fromARGB(255, 153, 153, 153),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
