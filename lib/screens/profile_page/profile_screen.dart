import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/form_fields/custom_dropdown_form_field.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/modalities_grid.dart';

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
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider
        .loadUserProfile(); // Método para carregar os dados do perfil
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
      await profileProvider
          .clearUserData(); // Método para limpar os dados do usuário
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      ); // Redirecionar para a tela de login
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                        CustomDropdownFormField(
                          value: profileProvider.selectedClass,
                          items: profileProvider.classes,
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
                          selectedModalityIds:
                              profileProvider.selectedModalityIds,
                          isEditing: profileProvider.isEditing,
                          onModalityChanged: profileProvider.onModalityChanged,
                        ),
                        if (profileProvider.modalityError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              profileProvider.modalityError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 20),
                        profileProvider.isEditing
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: profileProvider.isFormValid &&
                                          profileProvider
                                              .selectedModalityIds.isNotEmpty
                                      ? () {
                                          FocusScope.of(context).unfocus();
                                          profileProvider.saveProfile(_formKey);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        profileProvider.isFormValid &&
                                                profileProvider
                                                    .selectedModalityIds
                                                    .isNotEmpty
                                            ? Colors.red
                                            : Colors.grey,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Salvar',
                                      style: TextStyle(fontSize: 18)),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    profileProvider.toggleEditing();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 243, 33, 33),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Editar',
                                      style: TextStyle(fontSize: 18)),
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
