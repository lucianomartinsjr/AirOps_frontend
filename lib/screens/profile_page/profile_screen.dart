import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/api/api_service.dart';
import '../../widgets/form_fields/custom_dropdown_form_field.dart';
import '../../widgets/form_fields/custom_text_form_field.dart';
import '../../widgets/form_fields/modalities_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../utils/cities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      _initializeProfile(profileProvider);
    });
  }

  Future<void> _initializeProfile(ProfileProvider profileProvider) async {
    // Carregar dados do cache local
    await _loadCachedProfile(profileProvider);

    // Buscar dados atualizados do servidor
    await profileProvider.initialize(ApiService());

    // Comparar e atualizar se necessário
    if (_profileHasChanged(profileProvider)) {
      await _updateCachedProfile(profileProvider);
      setState(() {}); // Atualizar a interface do usuário
    }
  }

  Future<void> _loadCachedProfile(ProfileProvider profileProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedProfileJson = prefs.getString('cached_profile');
    if (cachedProfileJson != null) {
      Map<String, dynamic> cachedProfile = json.decode(cachedProfileJson);
      profileProvider.loadFromCache(cachedProfile);
    }
  }

  bool _profileHasChanged(ProfileProvider profileProvider) {
    // Implemente a lógica de comparação aqui
    // Retorne true se o perfil do servidor for diferente do cache local
    // Esta é uma implementação simplificada, você pode precisar ajustá-la
    return profileProvider.hasChanges;
  }

  Future<void> _updateCachedProfile(ProfileProvider profileProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileJson = json.encode(profileProvider.toJson());
    await prefs.setString('cached_profile', profileJson);
  }

  Future<void> _logout(
      BuildContext context, ProfileProvider profileProvider) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirmar Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: 64,
                color: Colors.white70,
              ),
              SizedBox(height: 16),
              Text(
                'Você tem certeza que deseja sair?',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildProfileHeader(profileProvider),
                          Form(
                            key: _formKey,
                            onChanged: profileProvider.validateForm,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFormSection(
                                  title: 'Informações Pessoais',
                                  children: [
                                    CustomTextFormField(
                                      controller:
                                          profileProvider.nameController,
                                      labelText: 'Nome Completo *',
                                      readOnly: !profileProvider.isEditing,
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
                                      controller:
                                          profileProvider.nicknameController,
                                      labelText: 'Apelido (Opcional)',
                                      readOnly: !profileProvider.isEditing,
                                      prefixIcon: const Icon(Icons.face),
                                    ),
                                  ],
                                ),
                                _buildFormSection(
                                  title: 'Localização e Contato',
                                  children: [
                                    CidadesUtil
                                        .construirCampoAutocompleteCidade(
                                      controller:
                                          profileProvider.cityController,
                                      onChanged: (newValue) {
                                        if (newValue != null) {
                                          // Use Future.microtask para evitar chamar setState durante a construção
                                          Future.microtask(() {
                                            profileProvider.validateForm();
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, selecione uma cidade';
                                        }
                                        return null;
                                      },
                                      readOnly: !profileProvider.isEditing,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      controller:
                                          profileProvider.phoneController,
                                      labelText: 'Telefone *',
                                      readOnly: !profileProvider.isEditing,
                                      prefixIcon: const Icon(Icons.phone),
                                      validator: (value) {
                                        if (profileProvider.isEditing) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, insira seu telefone';
                                          }
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
                                      value: profileProvider.selectedClass,
                                      items: profileProvider.classes
                                          .where((classItem) =>
                                              classItem.ativo ?? false)
                                          .map((classItem) =>
                                              classItem.id.toString())
                                          .toList(),
                                      labelText:
                                          'Qual classe você mais joga? *',
                                      readOnly: !profileProvider.isEditing,
                                      prefixIcon:
                                          const Icon(Icons.sports_esports),
                                      validator: (value) {
                                        if (profileProvider.isEditing &&
                                            value == null) {
                                          return 'Por favor, selecione uma classe';
                                        }
                                        return null;
                                      },
                                      onChanged: (newValue) {
                                        profileProvider.selectedClass =
                                            newValue;
                                        profileProvider.validateForm();
                                      },
                                      itemAsString: (String item) {
                                        final classItem =
                                            profileProvider.classes.firstWhere(
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    const SizedBox(height: 10),
                                    ModalitiesGrid(
                                      modalities: profileProvider.modalities
                                          .where((modality) => modality.ativo)
                                          .toList(), // Filtrar apenas modalidades ativas
                                      selectedModalityIds: profileProvider
                                          .selectedModalities
                                          .map((modality) => modality.id!)
                                          .toList(),
                                      isEditing: profileProvider.isEditing,
                                      onModalityChanged:
                                          profileProvider.onModalityChanged,
                                    ),
                                  ],
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (profileProvider.isEditing) {
                          await profileProvider.saveProfile(_formKey);
                        } else {
                          profileProvider.toggleEditing();
                        }
                      },
                      icon: Icon(
                        profileProvider.isEditing ? Icons.save : Icons.edit,
                        color: Colors.white,
                      ),
                      label: Text(
                        profileProvider.isEditing ? 'Salvar' : 'Editar',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: profileProvider.isEditing
                          ? Colors.green
                          : Colors.grey[850],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileProvider profileProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Text(
              profileProvider.nameController.text.isNotEmpty
                  ? profileProvider.nameController.text[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Modificação aqui para exibir o primeiro e último nome
                  _getFirstAndLastName(profileProvider.nameController.text),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  profileProvider.nicknameController.text.isNotEmpty
                      ? profileProvider.nicknameController.text
                      : 'Sem apelido',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFirstAndLastName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first} ${nameParts.last}';
    } else {
      return fullName;
    }
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
}
