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
        childAspectRatio: 3 / 2,
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
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.red : Colors.white,
              ),
              borderRadius: BorderRadius.circular(8),
              color:
                  isSelected ? Colors.red.withOpacity(0.3) : Colors.transparent,
            ),
            child: Center(
              child: Text(
                modality.descricao,
                style: TextStyle(
                  color: isSelected ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
