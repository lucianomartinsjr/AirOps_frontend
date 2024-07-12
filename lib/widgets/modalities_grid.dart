import 'package:flutter/material.dart';
import '../models/modality.dart';

class ModalitiesGrid extends StatelessWidget {
  final List<Modality> modalities;
  final List<String> selectedModalityIds;
  final bool isEditing;
  final Function(bool, String) onModalityChanged;

  ModalitiesGrid({
    required this.modalities,
    required this.selectedModalityIds,
    required this.isEditing,
    required this.onModalityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
      childAspectRatio: 5,
      physics: const NeverScrollableScrollPhysics(),
      children: modalities.map((modality) {
        final isSelected = selectedModalityIds.contains(modality.id);
        final borderColor = isEditing || !isSelected
            ? const Color.fromARGB(255, 80, 80, 80)
            : Color.fromARGB(141, 85, 85, 85).withOpacity(0.5);
        final backgroundColor = isEditing
            ? (isSelected
                ? const Color.fromARGB(255, 243, 33, 33).withOpacity(0.8)
                : Colors.transparent)
            : (isSelected
                ? Color.fromARGB(255, 74, 74, 74).withOpacity(0.8)
                : Color.fromARGB(0, 255, 255, 255));

        return InkWell(
          onTap: isEditing
              ? () {
                  onModalityChanged(!isSelected, modality.id);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                modality.name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
