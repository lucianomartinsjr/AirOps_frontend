import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;

  const DateTimePickerField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.prefixIcon,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.red),
            dialogBackgroundColor: const Color(0xFF2F2F2F),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(primary: Colors.red),
                dialogBackgroundColor: const Color(0xFF2F2F2F),
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          final DateTime pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          controller.text =
              DateFormat('dd/MM/yyyy HH:mm').format(pickedDateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDateTime(context),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF2F2F2F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      validator: validator,
    );
  }
}
