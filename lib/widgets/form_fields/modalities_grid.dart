import 'package:flutter/material.dart';
import '../../models/modality.dart';

class ModalitiesGrid extends StatelessWidget {
  final List<Modality> modalities;
  final List<int> selectedModalityIds;
  final bool isEditing;
  final Function(bool, int) onModalityChanged;

  const ModalitiesGrid({
    super.key,
    required this.modalities,
    required this.selectedModalityIds,
    required this.isEditing,
    required this.onModalityChanged,
  });

  void _showRules(BuildContext context, String rules) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: const Text(
          'Regras da Modalidade',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          rules,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Fechar',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: modalities.length,
      itemBuilder: (ctx, index) {
        final modality = modalities[index];
        final isSelected = selectedModalityIds.contains(modality.id);

        return GestureDetector(
          onTap: isEditing
              ? () {
                  onModalityChanged(!isSelected, modality.id);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isEditing
                    ? (isSelected ? Colors.red : Colors.white)
                    : Colors.grey, // Cor da borda cinza quando não editável
              ),
              borderRadius: BorderRadius.circular(8),
              color: isEditing
                  ? (isSelected
                      ? Colors.red.withOpacity(0.3)
                      : const Color.fromARGB(255, 39, 39, 39))
                  : const Color.fromARGB(255, 92, 92, 92).withOpacity(
                      0.3), // Cor de fundo cinza quando não editável
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      modality.descricao,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isEditing
                            ? (isSelected
                                ? const Color.fromARGB(255, 196, 196, 196)
                                : Colors.white)
                            : const Color.fromARGB(255, 189, 189,
                                189), // Cor do texto cinza escuro quando não editável
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.help_outline, size: 16),
                    color: Colors.grey,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      _showRules(context, modality.regras);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
