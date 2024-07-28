import 'package:airops_frontend/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/modality.dart';
import '../../services/airsoft_service.dart';
import '../../models/game.dart';
import '../../services/api_service.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/form_fields/date_time_picker_field.dart';
import '../../widgets/form_fields/custom_dropdown_form_field.dart'; // Importar aqui

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
  List<Modality> _modalities = [];
  Modality? _selectedModality;
  String? _selectedPeriod;

  bool _isFree = false; // Controla o estado do switch

  final List<String> _cities = [
    'Rio Verde/GO',
    'Santa Helena/GO',
    'Jatai/GO',
    'Montividiu/GO',
  ];

  final List<String> _periods = [
    'Matutino',
    'Vespertino',
    'Noturno',
  ];

  @override
  void initState() {
    super.initState();
    _fetchModalities();
  }

  Future<void> _fetchModalities() async {
    try {
      List<Modality> modalities =
          await Provider.of<ApiService>(context, listen: false)
              .fetchModalities();
      setState(() {
        _modalities = modalities;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Erro ao buscar modalidades: $error");
      }
    }
  }

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
    return null;
  }

  DateTime _parseDate(String dateStr) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.parse(dateStr);
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
                        labelText: 'Titulo *',
                        readOnly: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o titulo do jogo';
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
                      Row(
                        children: [
                          Expanded(
                            child: DateTimePickerField(
                              controller: _dateController,
                              labelText: 'Data e Hora *',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecione a data e a hora';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomDropdownFormField<String>(
                              value: _selectedPeriod,
                              items: _periods,
                              labelText: 'Período *',
                              readOnly: false,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPeriod = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor, selecione o período';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownFormField<Modality>(
                        value: _selectedModality,
                        items: _modalities,
                        labelText: 'Modalidade *',
                        readOnly: false,
                        itemAsString: (Modality modality) => modality.descricao,
                        onChanged: (Modality? newValue) {
                          setState(() {
                            _selectedModality = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione a modalidade';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: _numMaxOperadoresController,
                              labelText: 'Núm. Máx. de Operadores *',
                              readOnly: false,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira o número máximo de operadores';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              controller: _feeController,
                              labelText: 'Taxa *',
                              readOnly: _isFree,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (_isFree ||
                                    (value != null && value.isNotEmpty)) {
                                  return null;
                                }
                                return 'Por favor, insira a taxa';
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              const Text('Gratuito'),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _isFree,
                                  onChanged: (value) {
                                    setState(() {
                                      _isFree = value;
                                      if (_isFree == true) {
                                        _feeController.text = '0';
                                      }
                                    });
                                  },
                                  activeColor: Colors.red,
                                  activeTrackColor: Colors.red.withOpacity(0.5),
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                        dataEvento: _parseDate(_dateController.text),
                        idModalidadeJogo: _selectedModality!.id,
                        periodo: _selectedPeriod!,
                        nomeOrganizador: _organizerController.text,
                        valor: double.parse(_feeController.text),
                        imagemCapa: _imageUrlController.text,
                        descricao: _detailsController.text,
                        linkCampo: _locationLinkController.text,
                        numMaxOperadores:
                            int.parse(_numMaxOperadoresController.text),
                      );
                      Provider.of<AirsoftService>(context, listen: false)
                          .addGame(newGame, context);
                      Navigator.of(context)
                          .pushReplacementNamed('/home-screen');
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
