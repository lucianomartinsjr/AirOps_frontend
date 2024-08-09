import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final TextEditingController controller;

  const PasswordStrengthIndicator({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final strength = _calculatePasswordStrength(value.text);
        final color = _getStrengthColor(strength);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Força da Senha', style: TextStyle(color: color)),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: strength,
              color: color,
              backgroundColor: Colors.grey[300],
            ),
          ],
        );
      },
    );
  }

  double _calculatePasswordStrength(String password) {
    if (password.length < 6) {
      return 0.1; // A senha deve ter no mínimo 6 caracteres
    }
    if (password.length < 8) return 0.3;
    if (password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$&*~]'))) {
      return 1.0;
    }
    return 0.7;
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.3) return Colors.red;
    if (strength <= 0.7) return Colors.orange;
    return Colors.green;
  }
}
