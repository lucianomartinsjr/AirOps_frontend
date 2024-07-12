import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart'; // Import the package
import '../../../models/modality.dart';
import '../../../services/api_service.dart';

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
    Key? key,
    required this.nameController,
    required this.nicknameController,
    required this.cityController,
    required this.phoneController,
    required this.onClassChanged,
    required this.onModalityChanged,
    required this.onPrevious,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClass;
  final List<String> _selectedModalityIds = [];
  List<String> _classes = [];
  List<Modality> _modalities = [];
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
    _fetchModalities();
  }

  Future<void> _fetchClasses() async {
    List<String> classes =
        await Provider.of<ApiService>(context, listen: false).fetchClasses();
    setState(() {
      _classes = classes;
    });
  }

  Future<void> _fetchModalities() async {
    List<Modality> modalities =
        await Provider.of<ApiService>(context, listen: false).fetchModalities();
    setState(() {
      _modalities = modalities;
    });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onChanged: _validateForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  ' -  Complete seu Perfil  -',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nome Completo * ',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2F2F2F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: widget.nicknameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Apelido (Opcional)',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2F2F2F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  items: _classes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedClass = newValue;
                    });
                    widget.onClassChanged(newValue);
                    _validateForm();
                  },
                  decoration: InputDecoration(
                    labelText: 'Qual classe você mais joga ?  * ',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2F2F2F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma classe';
                    }
                    return null;
                  },
                  dropdownColor: const Color(0xFF2F2F2F),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: widget.cityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Cidade * ',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2F2F2F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua cidade';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: widget.phoneController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Telefone  *  ',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2F2F2F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  inputFormatters: [
                    MaskedInputFormatter('(##) # ####-####'),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu telefone';
                    } else if (value.length < 16) {
                      return 'Por favor, insira um telefone válido no formato \n(XX) X XXXX-XXXX';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  '-  Modalidades Preferidas  -  * ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _modalities.map((modality) {
                    final isSelected =
                        _selectedModalityIds.contains(modality.id);
                    return InkWell(
                      onTap: () {
                        _onModalityChanged(!isSelected, modality.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.red : Colors.transparent,
                          border: Border.all(
                              color: const Color.fromARGB(255, 64, 64, 64)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            modality.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid && _selectedModalityIds.isNotEmpty
                        ? () {
                            FocusScope.of(context).unfocus();
                            widget.onSubmit();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isFormValid && _selectedModalityIds.isNotEmpty
                              ? Colors.red
                              : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        const Text('Cadastrar', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    widget.onPrevious();
                  },
                  child: const Text('Voltar',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
