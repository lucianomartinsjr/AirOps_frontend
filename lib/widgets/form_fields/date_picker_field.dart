import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const DatePickerField({
    required this.controller,
    required this.labelText,
    this.validator,
    super.key,
  });

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'), // Define o locale aqui
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.red,
            hintColor: Colors.red,
            colorScheme: const ColorScheme.dark(primary: Colors.red),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        widget.controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF2F2F2F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      readOnly: true,
      onTap: _selectDate,
      validator: widget.validator,
    );
  }
}
