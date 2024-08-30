import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/api/api_service.dart';
import '../../widgets/form_fields/custom_dropdown_form_field.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/form_fields/modalities_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.initialize(ApiService());
    });
  }

  Future<void> _logout(
      BuildContext context, ProfileProvider profileProvider) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text('Confirmar Logout',
              style: TextStyle(color: Colors.white)),
          content: const Text('Você tem certeza que deseja sair?',
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child:
                  const Text('Confirmar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await profileProvider.clearUserData();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () => _logout(context, profileProvider),
                    child: const Text(
                      '←   Logout',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const Spacer(),
                Tooltip(
                  message: 'Alterar senha',
                  child: IconButton(
                    icon: const Icon(Icons.key_sharp),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/change-password');
                    },
                  ),
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    onChanged: profileProvider.validateForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '- Clique na chave para alterar sua senha -',
                          style: TextStyle(color: Colors.white30, fontSize: 10),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: profileProvider.nameController,
                          labelText: 'Nome Completo *',
                          readOnly: !profileProvider.isEditing,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu nome completo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: profileProvider.nicknameController,
                          labelText: 'Apelido (Opcional)',
                          readOnly: !profileProvider.isEditing,
                        ),
                        const SizedBox(height: 10),
                        CustomDropdownFormField<String>(
                          value: profileProvider.selectedClass,
                          items: profileProvider.classes
                              .map((classItem) => classItem.id.toString())
                              .toList(),
                          labelText: 'Qual classe você mais joga? *',
                          readOnly: !profileProvider.isEditing,
                          validator: (value) {
                            if (profileProvider.isEditing && value == null) {
                              return 'Por favor, selecione uma classe';
                            }
                            return null;
                          },
                          onChanged: (newValue) {
                            profileProvider.selectedClass = newValue;
                            profileProvider.validateForm();
                          },
                          itemAsString: (String item) {
                            final classItem =
                                profileProvider.classes.firstWhere(
                              (classItem) => classItem.id.toString() == item,
                            );
                            return classItem.nomeClasse;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: profileProvider.cityController,
                          labelText: 'Cidade *',
                          readOnly: !profileProvider.isEditing,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira sua cidade';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: profileProvider.phoneController,
                          labelText: 'Telefone *',
                          readOnly: !profileProvider.isEditing,
                          validator: (value) {
                            if (profileProvider.isEditing) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu telefone';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Modalidades Preferidas *',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        ModalitiesGrid(
                          modalities: profileProvider.modalities,
                          selectedModalityIds: profileProvider
                              .selectedModalities
                              .map((modality) => modality.id!)
                              .toList(),
                          isEditing: profileProvider.isEditing,
                          onModalityChanged: profileProvider.onModalityChanged,
                        ),
                        if (profileProvider.modalityError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              profileProvider.modalityError!,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (profileProvider.isEditing) {
                                await profileProvider.saveProfile(_formKey);
                              } else {
                                profileProvider.toggleEditing();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: profileProvider.isEditing
                                  ? Colors.red
                                  : const Color.fromARGB(255, 243, 33, 33),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              profileProvider.isEditing ? 'Salvar' : 'Editar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
