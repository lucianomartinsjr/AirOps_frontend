import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:logging/logging.dart';
import '../../../models/class.dart';
import '../../../models/modality.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/cities.dart';
import '../../../widgets/form_fields/custom_dropdown_form_field.dart';
import '../../../widgets/form_fields/custom_text_form_field.dart';
import '../../../widgets/form_fields/modalities_grid.dart';

class ProfilePage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController nicknameController;
  final TextEditingController cityController;
  final TextEditingController phoneController;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<List<String>> onModalityChanged;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const ProfilePage({
    super.key,
    required this.nameController,
    required this.nicknameController,
    required this.cityController,
    required this.phoneController,
    required this.onClassChanged,
    required this.onModalityChanged,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClassId;
  final List<String> _selectedModalityIds = [];
  List<Class> _classes = [];
  List<Modality> _modalities = [];
  bool _isFormValid = false;
  final _logger = Logger('ProfilePage');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
    _fetchModalities();
  }

  Future<void> _fetchClasses() async {
    try {
      List<Class> classes =
          await Provider.of<ApiService>(context, listen: false).fetchClasses();
      setState(() {
        _classes = classes;
      });
    } catch (error) {
      _logger.warning('Erro ao buscar classes', error);
    }
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

  void _onModalityChanged(bool selected, String modalityId) {
    setState(() {
      if (selected) {
        _selectedModalityIds.add(modalityId);
      } else {
        _selectedModalityIds.remove(modalityId);
      }
      widget.onModalityChanged(_selectedModalityIds);
      _validateForm();
    });
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
      _isFormValid = _isFormValid &&
          _selectedModalityIds.isNotEmpty &&
          _selectedClassId != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  onChanged: _validateForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormSection(
                        title: 'Informações Pessoais',
                        children: [
                          CustomTextFormField(
                            controller: widget.nameController,
                            labelText: 'Nome Completo *',
                            readOnly: false,
                            prefixIcon: const Icon(Icons.person),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu nome completo';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: widget.nicknameController,
                            labelText:
                                'Você utiliza algum apelido?  (Opcional)',
                            readOnly: false,
                            prefixIcon: const Icon(Icons.face),
                          ),
                        ],
                      ),
                      _buildFormSection(
                        title: 'Localização e Contato',
                        children: [
                          _buildCityField(),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: widget.phoneController,
                            labelText: 'Telefone *',
                            prefixIcon: const Icon(Icons.phone),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              MaskedInputFormatter('(##) # ####-####'),
                            ],
                            readOnly: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu telefone';
                              } else if (value.length < 16) {
                                return 'Por favor, insira um telefone válido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      _buildFormSection(
                        title: 'Preferências de Jogo',
                        children: [
                          CustomDropdownFormField<String>(
                            value: _selectedClassId,
                            items: _classes
                                .where((classItem) => classItem.ativo ?? false)
                                .map((classItem) => classItem.id.toString())
                                .toList(),
                            readOnly: false,
                            labelText: 'Qual classe você mais joga? *',
                            prefixIcon: const Icon(Icons.sports_esports),
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, selecione uma classe';
                              }
                              return null;
                            },
                            onChanged: (newValue) {
                              setState(() {
                                _selectedClassId = newValue;
                              });
                              widget.onClassChanged(newValue);
                              _validateForm();
                            },
                            itemAsString: (String item) {
                              final classItem = _classes.firstWhere(
                                (classItem) =>
                                    classItem.id.toString() == item &&
                                    (classItem.ativo ?? false),
                              );
                              return classItem.nomeClasse;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Modalidades Preferidas *',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          ModalitiesGrid(
                            modalities: _modalities
                                .where((modality) => modality.ativo)
                                .toList(),
                            selectedModalityIds:
                                _selectedModalityIds.map(int.parse).toList(),
                            isEditing: true,
                            onModalityChanged:
                                (bool isSelected, int modalityId) {
                              _onModalityChanged(
                                  isSelected, modalityId.toString());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const SizedBox(height: 160),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: ElevatedButton(
                  onPressed:
                      (_isFormValid && !isLoading) ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildCityField() {
    return CidadesUtil.construirCampoAutocompleteCidade(
      controller: widget.cityController,
      readOnly: false,
      onChanged: (value) {
        setState(() {
          _validateForm();
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua cidade';
        }
        return null;
      },
    );
  }

  void _handleSubmit() {
    if (_isFormValid && _selectedModalityIds.isNotEmpty) {
      FocusScope.of(context).unfocus();
      widget.onSubmit();
    }
  }
}
