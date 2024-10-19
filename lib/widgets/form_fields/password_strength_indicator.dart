import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final TextEditingController controller;

  const PasswordStrengthIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final password = value.text;
        final strength = _calculatePasswordStrength(password);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Força da senha: ${_getStrengthLabel(strength)}',
              style: TextStyle(
                color: _getStrengthColor(strength),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: strength,
              backgroundColor: Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getStrengthColor(strength)),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            _buildStrengthTips(password),
          ],
        );
      },
    );
  }

  double _calculatePasswordStrength(String password) {
    // Implemente sua lógica de cálculo de força aqui
    // Este é um exemplo simples
    if (password.isEmpty) return 0;
    double strength = 0;
    if (password.length > 8) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;
    return strength.clamp(0.0, 1.0);
  }

  String _getStrengthLabel(double strength) {
    if (strength < 0.3) return 'Fraca';
    if (strength < 0.7) return 'Média';
    return 'Forte';
  }

  Color _getStrengthColor(double strength) {
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  Widget _buildStrengthTips(String password) {
    final tips = <String>[];
    if (!password.contains(RegExp(r'[A-Z]'))) {
      tips.add('Adicione letras maiúsculas');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      tips.add('Adicione letras minúsculas');
    }
    if (!password.contains(RegExp(r'[0-9]'))) tips.add('Adicione números');
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      tips.add('Adicione caracteres especiais');
    }
    if (password.length < 6) tips.add('Use pelo menos 6 caracteres');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tips
          .map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(tip,
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
