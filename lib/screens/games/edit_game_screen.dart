import 'package:airops_frontend/widgets/form_fields/date_time_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/airsoft_service.dart';
import '../../models/game.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';

class EditGameScreen extends StatefulWidget {
  final Game game;

  const EditGameScreen({super.key, required this.game});

  @override
  _EditGameScreenState createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _fieldTypeController;
  late TextEditingController _detailsController;
  late TextEditingController _organizerController;
  late TextEditingController _feeController;
  late TextEditingController _imageUrlController;
  late TextEditingController _locationLinkController;
  late TextEditingController _numMaxOperadoresController;
  late TextEditingController _modalityController;
  late TextEditingController _periodController;

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

  final List<String> _periods = ['Matutino', 'Vespertino', 'Noturno'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.game.titulo);
    _locationController = TextEditingController(text: widget.game.cidade);
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy HH:mm').format(widget.game.dataEvento),
    );
    _detailsController = TextEditingController(text: widget.game.descricao);
    _organizerController =
        TextEditingController(text: widget.game.nomeOrganizador);
    _feeController = TextEditingController(text: widget.game.valor.toString());
    _imageUrlController = TextEditingController(text: widget.game.imagemCapa);
    _locationLinkController =
        TextEditingController(text: widget.game.linkCampo);
    _numMaxOperadoresController =
        TextEditingController(text: widget.game.numMaxOperadores.toString());
    _modalityController =
        TextEditingController(text: widget.game.idModalidadeJogo.toString());
    _periodController = TextEditingController(text: widget.game.periodo);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _fieldTypeController.dispose();
    _detailsController.dispose();
    _organizerController.dispose();
    _feeController.dispose();
    _imageUrlController.dispose();
    _locationLinkController.dispose();
    _numMaxOperadoresController.dispose();
    _modalityController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  Future<void> _updateGame() async {
    if (_formKey.currentState!.validate()) {
      final updatedGame = Game(
        id: widget.game.id,
        titulo: _nameController.text,
        cidade: _locationController.text,
        dataEvento: DateFormat('dd/MM/yyyy HH:mm').parse(_dateController.text),
        idModalidadeJogo: int.parse(_modalityController.text),
        periodo: _periodController.text,
        nomeOrganizador: _organizerController.text,
        valor: double.parse(_feeController.text),
        imagemCapa: _imageUrlController.text,
        descricao: _detailsController.text,
        linkCampo: _locationLinkController.text,
        numMaxOperadores: int.parse(_numMaxOperadoresController.text),
      );

      try {
        await Provider.of<AirsoftService>(context, listen: false)
            .updateGame(widget.game.id ?? 0, updatedGame);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao atualizar o jogo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Editar Jogo'),
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
                        initialValue: TextEditingValue(
                          text: widget.game.cidade,
                        ),
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          fieldTextEditingController.text =
                              _locationController.text;
                          return CustomTextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            labelText: 'Cidade/UF *',
                            readOnly: false,
                            maxLines: 1,
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
                        value: int.tryParse(_modalityController.text),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Período *',
                        ),
                        items: _periods.map((period) {
                          return DropdownMenuItem<String>(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          _periodController.text = newValue!;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione o período';
                          }
                          return null;
                        },
                        value: _periodController.text,
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
                      const SizedBox(
                        height: 80,
                      ),
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
                  onPressed: _updateGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Salvar Alterações',
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
