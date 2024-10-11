import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final int? maxLines;
  final FocusNode? focusNode;
  final Widget? prefixIcon; // Adicionado

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.readOnly,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onTap,
    this.maxLines = 1,
    this.focusNode,
    this.prefixIcon, // Adicionado
    super.key,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.obscureText || widget.maxLines == 1,
        'Obscured fields cannot be multiline.');

    return Opacity(
      opacity: widget.readOnly ? 0.5 : 1.0,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText && widget.maxLines == 1,
        style: const TextStyle(color: Colors.white),
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
          prefixIcon: widget.prefixIcon, // Adicionado
          suffixIcon: widget.obscureText && widget.maxLines == 1
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        readOnly: widget.readOnly,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
      ),
    );
  }
}
