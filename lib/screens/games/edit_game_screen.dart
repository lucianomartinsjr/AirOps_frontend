import 'package:airops_frontend/widgets/form_fields/date_time_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/api/airsoft_service.dart';
import '../../models/game.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/form_fields/custom_dropdown_form_field.dart';
import '../../models/modality.dart';
import '../../services/api/api_service.dart';
import 'package:logging/logging.dart';

class EditGameScreen extends StatefulWidget {
  final Game game;

  const EditGameScreen({super.key, required this.game});

  @override
  EditGameScreenState createState() => EditGameScreenState();
}

class EditGameScreenState extends State<EditGameScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _detailsController;
  late TextEditingController _organizerController;
  late TextEditingController _feeController;
  late TextEditingController _locationLinkController;
  late TextEditingController _numMaxOperadoresController;
  late TextEditingController _periodController;
  late TextEditingController _imageUrlController;

  List<Modality> _modalities = [];
  Modality? _selectedModality;
  String? _selectedPeriod;
  bool _isFree = false;

  final List<String> _cities = [
    'Rio Verde/GO',
    'Santa Helena/GO',
    'Jatai/GO',
    'Montividiu/GO',
  ];

  final List<String> _periods = ['Matutino', 'Vespertino', 'Noturno'];

  final _logger = Logger('EditGameScreenState');

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
    _locationLinkController =
        TextEditingController(text: widget.game.linkCampo);
    _numMaxOperadoresController =
        TextEditingController(text: widget.game.numMaxOperadores.toString());
    _periodController = TextEditingController(text: widget.game.periodo);
    _imageUrlController = TextEditingController();

    _isFree = widget.game.valor == 0;

    _fetchModalities().then((_) {
      setState(() {
        _selectedModality = _modalities.firstWhere(
          (modality) => modality.id == widget.game.idModalidadeJogo,
          orElse: () => _modalities.first,
        );
        _selectedPeriod = widget.game.periodo;
      });
    });
  }

  Future<void> _fetchModalities() async {
    try {
      List<Modality> modalities =
          await Provider.of<ApiService>(context, listen: false)
              .fetchModalities();
      if (mounted) {
        setState(() {
          _modalities = modalities;
        });
      }
    } catch (error) {
      _logger.warning("Erro ao buscar modalidades: $error");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _detailsController.dispose();
    _organizerController.dispose();
    _feeController.dispose();
    _locationLinkController.dispose();
    _numMaxOperadoresController.dispose();
    _periodController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateGame() async {
    if (_formKey.currentState!.validate()) {
      final updatedGame = Game(
        id: widget.game.id,
        titulo: _nameController.text,
        cidade: _locationController.text,
        dataEvento: DateFormat('dd/MM/yyyy HH:mm').parse(_dateController.text),
        idModalidadeJogo: _selectedModality?.id ?? widget.game.idModalidadeJogo,
        periodo: _selectedPeriod!,
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
        if (mounted) {
          // Notificar a tela anterior para recarregar os jogos
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao atualizar o jogo: $e')),
          );
        }
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
                        labelText: 'Título do Jogo',
                        readOnly: false,
                        prefixIcon:
                            const Icon(Icons.title, color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
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
                          fieldTextEditingController.text =
                              _locationController.text;
                          return CustomTextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            labelText: 'Localização',
                            readOnly: false,
                            maxLines: 1,
                            prefixIcon: const Icon(Icons.location_on,
                                color: Colors.white),
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
                              labelText: 'Data e Hora',
                              prefixIcon:
                                  const Icon(Icons.event, color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Selecione a data e hora';
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
                              labelText: 'Período',
                              readOnly: false,
                              prefixIcon: const Icon(Icons.access_time,
                                  color: Colors.white),
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
                        labelText: 'Modalidade',
                        readOnly: false,
                        prefixIcon:
                            const Icon(Icons.category, color: Colors.white),
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
                              labelText: 'Máx. Operadores',
                              readOnly: false,
                              prefixIcon:
                                  const Icon(Icons.group, color: Colors.white),
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
                              labelText: 'Taxa',
                              readOnly: _isFree,
                              prefixIcon: const Icon(Icons.attach_money,
                                  color: Colors.white),
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
                        controller: _locationLinkController,
                        labelText: 'Link do Maps',
                        readOnly: false,
                        prefixIcon: const Icon(Icons.map, color: Colors.white),
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
                        labelText: 'Detalhes do Jogo',
                        readOnly: false,
                        prefixIcon:
                            const Icon(Icons.description, color: Colors.white),
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
