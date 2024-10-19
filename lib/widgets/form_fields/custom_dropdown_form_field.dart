import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String labelText;
  final bool readOnly;
  final FormFieldValidator<T>? validator;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemAsString;
  final Widget? prefixIcon; // Adicionado
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.readOnly,
    this.validator,
    this.onChanged,
    this.itemAsString,
    this.prefixIcon, // Adicionado
    this.borderRadius = 8.0,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: readOnly ? 0.5 : 1.0,
      child: DropdownButtonFormField<T>(
        value: items.contains(value) ? value : null,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemAsString != null ? itemAsString!(item) : item.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: readOnly ? null : onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF2F2F2F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          contentPadding: contentPadding,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: prefixIcon,
                )
              : null,
          suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
        validator: validator,
        dropdownColor: const Color(0xFF2F2F2F),
        icon: const SizedBox.shrink(), // Remove o ícone padrão
        isExpanded:
            true, // Expande o dropdown para preencher o espaço disponível
        menuMaxHeight: 300, // Limita a altura máxima do menu dropdown
      ),
    );
  }
}
