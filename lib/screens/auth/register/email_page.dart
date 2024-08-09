import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api/api_service.dart';

class EmailPage extends StatefulWidget {
  final TextEditingController emailController;
  final VoidCallback onNext;

  const EmailPage({
    super.key,
    required this.emailController,
    required this.onNext,
  });

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _emailExists = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateForm);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateForm);
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkEmail() async {
    bool emailExists = await Provider.of<ApiService>(context, listen: false)
        .checkEmail(widget.emailController.text);
    setState(() {
      _emailExists = emailExists;
    });
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email';
    }
    String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF222222),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            onChanged: _validateForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Insira seu Email',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.emailController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2F2F2F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _emailValidator,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid
                        ? () async {
                            FocusScope.of(context).unfocus();
                            await _checkEmail();
                            if (!_emailExists) {
                              widget.onNext();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Email já cadastrado')),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? Colors.red : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        const Text('Próximo', style: TextStyle(fontSize: 18)),
                  ),
                ),
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
        ),
      ),
    );
  }
}
