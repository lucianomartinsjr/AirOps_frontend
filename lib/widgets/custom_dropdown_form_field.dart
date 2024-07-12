import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String labelText;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.readOnly,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: readOnly ? 0.5 : 1.0,
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
