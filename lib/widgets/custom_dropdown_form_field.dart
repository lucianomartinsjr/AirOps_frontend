import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
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
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  late TextEditingController _controller;
  late String? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _controller = TextEditingController(text: _currentValue);

    // Se o valor atual não estiver na lista de itens, define-o como nulo.
    if (_currentValue != null && !widget.items.contains(_currentValue)) {
      _currentValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color(0xFF2F2F2F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          readOnly: widget.readOnly,
          validator: widget.validator,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
        DropdownButtonFormField<String>(
          value: _currentValue,
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: widget.readOnly
              ? null
              : (value) {
                  setState(() {
                    _currentValue = value;
                    _controller.text = value!;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2F2F2F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          validator: widget.validator,
          dropdownColor: const Color(0xFF2F2F2F),
        ),
      ],
    );
  }
}
