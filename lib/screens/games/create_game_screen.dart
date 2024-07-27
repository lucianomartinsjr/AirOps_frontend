import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/airsoft_service.dart';
import '../../models/game.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/form_fields/date_time_picker_field.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _fieldTypeController = TextEditingController();
  final _modalityController = TextEditingController();
  final _periodController = TextEditingController();
  final _detailsController = TextEditingController();
  final _organizerController = TextEditingController();
  final _feeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationLinkController = TextEditingController();
  final _numMaxOperadoresController = TextEditingController();

  final List<String> _cities = [
    'Rio Verde/GO',
    'Santa Helena/GO',
    'Jatai/GO',
    'Montividiu/GO',
  ];

  final List<Map<String, dynamic>> _modalities = [
    {'id': 1, 'description': 'CQB'},
    {'id': 2, 'description': 'Floresta'},
    {'id': 3, 'description': 'Mista'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _fieldTypeController.dispose();
    _modalityController.dispose();
    _periodController.dispose();
    _detailsController.dispose();
    _organizerController.dispose();
    _feeController.dispose();
    _imageUrlController.dispose();
    _locationLinkController.dispose();
    _numMaxOperadoresController.dispose();
    super.dispose();
  }

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a localização';
    }
    final regex = RegExp(r'^[a-zA-Z\u00C0-\u017F]+/[A-Z]{2}$');
    if (!regex.hasMatch(value)) {
      return 'A localização deve estar no formato CIDADE/ES';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Criar Novo Jogo'),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Nome *',
                        readOnly: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do jogo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _cities.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          _locationController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return CustomTextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            labelText: 'Cidade/UF *',
                            readOnly: false,
                            maxLines: 1,
                            validator: _validateLocation,
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      child: ListTile(
                                        title: Text(option,
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      DateTimePickerField(
                        controller: _dateController,
                        labelText: 'Data e Hora *',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione a data e a hora';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _fieldTypeController,
                        labelText: 'Tipo de Campo *',
                        readOnly: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o tipo de campo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Modalidade *',
                        ),
                        items: _modalities.map((modality) {
                          return DropdownMenuItem<int>(
                            value: modality['id'],
                            child: Text(modality['description']),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          _modalityController.text = newValue.toString();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione a modalidade';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _periodController,
                        labelText: 'Período *',
                        readOnly: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o período';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _feeController,
                        labelText: 'Taxa *',
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a taxa';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _imageUrlController,
                        labelText: 'URL da Imagem *',
                        readOnly: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a URL da imagem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _locationLinkController,
                        labelText: 'Link do Maps *',
                        readOnly: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o link do Maps';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _numMaxOperadoresController,
                        labelText: 'Número Máximo de Operadores *',
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o número máximo de operadores';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _detailsController,
                        labelText: 'Detalhes',
                        readOnly: false,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newGame = Game(
                        titulo: _nameController.text,
                        cidade: _locationController.text,
                        dataEvento: DateTime.parse(_dateController.text),
                        idModalidadeJogo: int.parse(_modalityController.text),
                        periodo: _periodController.text,
                        nomeOrganizador: _organizerController.text,
                        valor: double.parse(_feeController.text),
                        imagemCapa: _imageUrlController.text,
                        descricao: _detailsController.text,
                        linkCampo: _locationLinkController.text,
                        numMaxOperadores:
                            int.parse(_numMaxOperadoresController.text),
                      );
                      Provider.of<AirsoftService>(context, listen: false)
                          .addGame(newGame);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Criar Jogo',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
