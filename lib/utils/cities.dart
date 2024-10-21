import 'package:flutter/material.dart';
import '../widgets/form_fields/custom_text_form_field.dart';
import 'cities_data.dart';

class CidadesUtil {
  static List<String> get cidades => CidadesData.cidades;

  static List<String> filtrarCidades(String consulta) {
    return cidades
        .where(
            (cidade) => cidade.toLowerCase().contains(consulta.toLowerCase()))
        .toList();
  }

  static Widget construirCampoAutocompleteCidade({
    required TextEditingController controller,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    required bool readOnly,
    String? initialValue,
  }) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '' || readOnly) {
          return const Iterable<String>.empty();
        }
        return filtrarCidades(textEditingValue.text);
      },
      onSelected: (String selection) {
        if (!readOnly) {
          controller.text = selection;
          onChanged(selection);
        }
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (fieldTextEditingController.text != controller.text) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  fieldTextEditingController.text = controller.text;
                });
              });
            }

            return CustomTextFormField(
              controller: fieldTextEditingController,
              labelText: 'Cidade *',
              readOnly: readOnly,
              validator: validator,
              prefixIcon:
                  const Icon(Icons.location_city, color: Colors.white70),
              onTap: readOnly ? null : () {},
              focusNode: fieldFocusNode,
              onChanged: (value) {
                controller.text = value;
                onChanged(value);
              },
            );
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Container(
                color: const Color(0xFF2F2F2F),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
