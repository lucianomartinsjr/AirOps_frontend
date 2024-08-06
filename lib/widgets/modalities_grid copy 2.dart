import 'package:flutter/material.dart';
import '../models/modality.dart';

class ModalitiesGrid extends StatelessWidget {
  final List<Modality> modalities;
  final List<Modality> selectedModalityIds;
  final bool isEditing;
  final void Function(bool, Modality) onModalityChanged;

  const ModalitiesGrid({
    super.key,
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
      itemCount: modalities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        final modality = modalities[index];
        final isSelected = selectedModalityIds.contains(modality);

        return GestureDetector(
          onTap: isEditing
              ? () {
                  onModalityChanged(!isSelected, modality);
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
