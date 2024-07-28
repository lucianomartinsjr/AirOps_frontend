import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String labelText;
  final bool readOnly;
  final FormFieldValidator<T>? validator;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemAsString;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.readOnly,
    this.validator,
    this.onChanged,
    this.itemAsString,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: readOnly ? 0.5 : 1.0,
      child: DropdownButtonFormField<T>(
        value: value,
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
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
        dropdownColor: const Color(0xFF2F2F2F),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
