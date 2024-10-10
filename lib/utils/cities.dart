import 'package:flutter/material.dart';

class CidadesUtil {
  static List<String> cidades = [
    'Goiânia - GO', 'Anápolis - GO', 'Aparecida de Goiânia - GO', 'Rio Verde - GO',
    'Luziânia - GO', 'Águas Lindas de Goiás - GO', 'Valparaíso de Goiás - GO',
    'Trindade - GO', 'Formosa - GO', 'Novo Gama - GO', 'Catalão - GO',
    'Itumbiara - GO', 'Jataí - GO', 'Caldas Novas - GO', 'Senador Canedo - GO',
    'Brasília - DF', 'São Paulo - SP', 'Rio de Janeiro - RJ', 'Belo Horizonte - MG',
    'Salvador - BA', 'Curitiba - PR', 'Fortaleza - CE', 'Manaus - AM',
    'Recife - PE', 'Porto Alegre - RS', 'Belém - PA'
  ];

  static List<String> filtrarCidades(String consulta) {
    return cidades
        .where((cidade) =>
            cidade.toLowerCase().contains(consulta.toLowerCase()))
        .toList();
  }

  static Widget construirCampoAutocompleteCidade({
    required TextEditingController controller,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return filtrarCidades(textEditingValue.text);
      },
      onSelected: (String selection) {
        controller.text = selection;
        onChanged(selection);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Cidade *',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color(0xFF2F2F2F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected,
          Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: Container(
              color: Colors.grey[850],
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option,
                          style: const TextStyle(color: Colors.white)),
                    ),
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


