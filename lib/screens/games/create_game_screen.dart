import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/modality.dart';
import '../../services/api/airsoft_service.dart';
import '../../models/game.dart';
import '../../services/api/api_service.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/form_fields/date_time_picker_field.dart';
import '../../widgets/form_fields/custom_dropdown_form_field.dart'; // Importar aqui

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  CreateGameScreenState createState() => CreateGameScreenState();
}

class CreateGameScreenState extends State<CreateGameScreen> {
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
        title: const Text('Criar Novo Jogo'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        _buildSection(
                          'Informaçes Básicas',
                          [
                            CustomTextFormField(
                              controller: _nameController,
                              labelText: 'Título do Jogo',
                              readOnly: false,
                              prefixIcon:
                                  const Icon(Icons.title, color: Colors.white),
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Campo obrigatório'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildLocationField(),
                            const SizedBox(height: 16),
                            _buildDateAndPeriodRow(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          'Detalhes do Jogo',
                          [
                            CustomDropdownFormField<Modality>(
                              value: _selectedModality,
                              items: _modalities,
                              labelText: 'Modalidade',
                              readOnly: false,
                              prefixIcon: const Icon(Icons.category,
                                  color: Colors.white),
                              itemAsString: (Modality modality) =>
                                  modality.descricao,
                              onChanged: (Modality? newValue) {
                                setState(() => _selectedModality = newValue);
                              },
                              validator: (value) => value == null
                                  ? 'Selecione uma modalidade'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildParticipantsAndFeeRow(),
                            const SizedBox(height: 16),
                            CustomTextFormField(
                              controller: _locationLinkController,
                              labelText: 'Link do Maps',
                              readOnly: false,
                              prefixIcon:
                                  const Icon(Icons.map, color: Colors.white),
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Insira o link do Maps'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormField(
                              controller: _detailsController,
                              labelText: 'Detalhes do Jogo',
                              readOnly: false,
                              prefixIcon: const Icon(Icons.description,
                                  color: Colors.white),
                              maxLines: 5,
                            ),
                          ],
                        ),
                        const SizedBox(height: 100), // Espaço para o botão fixo
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Criar Jogo',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildLocationField() {
    return Autocomplete<String>(
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
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return CustomTextFormField(
          controller: controller,
          focusNode: focusNode,
          labelText: 'Cidade/UF',
          readOnly: false,
          prefixIcon: const Icon(Icons.location_city, color: Colors.white),
          validator: _validateLocation,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return _buildAutocompleteOptions(options, onSelected);
      },
    );
  }

  Widget _buildAutocompleteOptions(
      Iterable<String> options, AutocompleteOnSelected<String> onSelected) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          color: Colors.grey[850],
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = options.elementAt(index);
              return InkWell(
                onTap: () => onSelected(option),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child:
                      Text(option, style: const TextStyle(color: Colors.white)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndPeriodRow() {
    return Column(
      children: [
        DateTimePickerField(
          controller: _dateController,
          labelText: 'Data e Hora',
          prefixIcon: const Icon(Icons.event, color: Colors.white),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Selecione a data e hora' : null,
        ),
        const SizedBox(height: 16),
        CustomDropdownFormField<String>(
          value: _selectedPeriod,
          items: _periods,
          labelText: 'Período',
          readOnly: false,
          prefixIcon: const Icon(Icons.access_time, color: Colors.white),
          onChanged: (String? newValue) {
            setState(() => _selectedPeriod = newValue);
          },
          validator: (value) => value == null ? 'Selecione o período' : null,
        ),
      ],
    );
  }

  Widget _buildParticipantsAndFeeRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildMaxOperatorsField(),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildFeeFieldWithSwitch(),
        ),
      ],
    );
  }

  Widget _buildMaxOperatorsField() {
    return CustomTextFormField(
      controller: _numMaxOperadoresController,
      labelText: 'Máx. Operadores',
      readOnly: false,
      prefixIcon: const Icon(Icons.group, color: Colors.white),
      keyboardType: TextInputType.number,
      validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildFeeFieldWithSwitch() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 60),
          child: CustomTextFormField(
            controller: _feeController,
            labelText: 'Taxa',
            readOnly: _isFree,
            prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
            keyboardType: TextInputType.number,
            validator: (value) => _isFree || (value?.isNotEmpty ?? false)
                ? null
                : 'Insira a taxa',
          ),
        ),
        Positioned(
          right: 8,
          child: _buildFreeSwitch(),
        ),
      ],
    );
  }

  Widget _buildFreeSwitch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: _isFree,
            onChanged: (value) {
              setState(() {
                _isFree = value;
                if (_isFree) {
                  _feeController.text = '0';
                } else {
                  _feeController.text = '';
                }
              });
            },
            activeColor: Colors.green,
            activeTrackColor: Colors.green.withOpacity(0.5),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[700],
          ),
        ),
        const Text('Gratuito', style: TextStyle(fontSize: 9)),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newGame = Game(
        titulo: _nameController.text,
        cidade: _locationController.text,
        dataEvento: _parseDate(_dateController.text),
        idModalidadeJogo: _selectedModality?.id ?? 0,
        periodo: _selectedPeriod!,
        nomeOrganizador: _organizerController.text,
        valor: double.parse(_feeController.text),
        imagemCapa:
            'https://rhtdycglcfuvyopxhhgl.supabase.co/storage/v1/object/sign/imagens/airops.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbWFnZW5zL2Fpcm9wcy5qcGciLCJpYXQiOjE3MjM0MDM1MjYsImV4cCI6MTc1NDkzOTUyNn0.-OEXSZO8n3LJdBW89FaL9Jc7dlk1saLCykVu46ymJts&t=2024-08-11T19%3A12%3A07.048Z',
        descricao: _detailsController.text,
        linkCampo: _locationLinkController.text,
        numMaxOperadores: int.parse(_numMaxOperadoresController.text),
      );

      Provider.of<AirsoftService>(context, listen: false)
          .addGame(newGame, context);
      Navigator.of(context).pushReplacementNamed('/home-screen');
    }
  }
}
