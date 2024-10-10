import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api/api_service.dart';
import 'package:flutter/services.dart';

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

class _EmailPageState extends State<EmailPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _emailExists = false;
  bool _isFormValid = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(_validateForm);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    widget.emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    widget.emailController.removeListener(_validateForm);
    _focusNode.dispose();
    _animationController.dispose();
    widget.emailController.removeListener(_onEmailChanged);
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

  void _onEmailChanged() {
    _validateForm();
    if (_emailValidator(widget.emailController.text) == null) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop('/login_screen'),
        ),
      ),
      backgroundColor: const Color(0xFF222222),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Qual é o seu e-mail?',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Usaremos este e-mail para criar sua conta.',
                  style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                ),
                const SizedBox(height: 32),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      controller: widget.emailController,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Seu e-mail',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF2F2F2F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: widget.emailController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  widget.emailController.clear();
                                  _validateForm();
                                },
                              )
                            : null,
                      ),
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _isFormValid ? _submitForm() : null,
                    ),
                    Positioned(
                      right: 12,
                      child: FadeTransition(
                        opacity: _animation,
                        child: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Insira um e-mail válido para continuar',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _submitForm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? Colors.red : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continuar', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    await _checkEmail();
    if (!_emailExists) {
      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este e-mail já está cadastrado')),
      );
    }
  }
}
