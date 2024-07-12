import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.readOnly,
    this.validator,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.readOnly ? 0.5 : 1.0,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
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
          suffixIcon: widget.obscureText
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
      ),
    );
  }
}
