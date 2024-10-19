import 'package:flutter/material.dart';
import '../../utils/cities_data.dart'; // Importe o arquivo cities_data.dart

class CityAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const CityAutocompleteField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  CityAutocompleteFieldState createState() => CityAutocompleteFieldState();
}

class CityAutocompleteFieldState extends State<CityAutocompleteField> {
  final GlobalKey _fieldKey = GlobalKey();
  double _fieldWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFieldWidth();
    });
  }

  void _updateFieldWidth() {
    final RenderBox? renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    setState(() {
      _fieldWidth = renderBox?.size.width ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return CidadesData.cidades.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        widget.controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          key: _fieldKey,
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color(0xFF2F2F2F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.location_city, color: Colors.white70),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white70),
              onPressed: () => textEditingController.clear(),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          validator: widget.validator,
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            color: const Color(0xFF2F2F2F),
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _fieldWidth,
                maxHeight: 200,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      onSelected(option);
                    },
                    hoverColor: Colors.white.withOpacity(0.1),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
