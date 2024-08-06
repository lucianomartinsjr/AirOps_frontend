import 'package:flutter/material.dart';
import '../models/modality.dart';

class ModalitiesGrid extends StatelessWidget {
  final List<Modality> modalities;
  final List<int> selectedModalityIds;
  final bool isEditing;
  final Function(bool, int) onModalityChanged;

  ModalitiesGrid({
    required this.modalities,
    required this.selectedModalityIds,
    required this.isEditing,
    required this.onModalityChanged,
  });

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
                      : Colors.transparent)
                  : Colors.grey.withOpacity(
                      0.3), // Cor de fundo cinza quando não editável
            ),
            child: Center(
              child: Text(
                modality.descricao,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isEditing
                      ? (isSelected ? Colors.red : Colors.white)
                      : const Color.fromARGB(255, 189, 189,
                          189), // Cor do texto cinza escuro quando não editável
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
