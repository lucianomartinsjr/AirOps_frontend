import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/profile.dart';
import '../models/modality.dart';
import '../services/api/api_service.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final _logger = Logger('ProfileProvider');

class ProfileProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedClass;
  List<Modality> selectedModalities = [];
  List<Class> classes = [];
  List<Modality> modalities = [];
  bool isFormValid = false;
  bool _isEditing = false;
  String? modalityError;
  bool hasChanges = false;

  late ApiService apiService;

  late Profile _originalProfile;
  late String _originalName;
  late String _originalNickname;
  late String _originalCity;
  late String _originalPhone;
  late String? _originalClass;
  late List<Modality> _originalModalities;

  Future<void> initialize(ApiService apiService) async {
    this.apiService = apiService;
    await loadCachedProfile();
    await loadUserProfile();

    // Armazene os valores originais
    _originalName = nameController.text;
    _originalNickname = nicknameController.text;
    _originalCity = cityController.text;
    _originalPhone = phoneController.text;
    _originalClass = selectedClass;
    _originalModalities = List.from(selectedModalities);
  }

  Future<void> loadCachedProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedProfileJson = prefs.getString('cached_profile');
      if (cachedProfileJson != null) {
        Map<String, dynamic> cachedProfile = json.decode(cachedProfileJson);
        loadFromCache(cachedProfile);
      }
    } catch (e) {
      _logger.warning('Erro ao carregar perfil do cache', e);
    }
  }

  void loadFromCache(Map<String, dynamic> cachedProfile) {
    nameController.text = cachedProfile['name'] ?? '';
    nicknameController.text = cachedProfile['nickname'] ?? '';
    cityController.text = cachedProfile['city'] ?? '';
    phoneController.text = cachedProfile['phone'] ?? '';
    selectedClass = cachedProfile['classId']?.toString();
    selectedModalities = (cachedProfile['modalities'] as List<dynamic>?)
            ?.map((modality) => Modality(
                id: modality['id'],
                descricao: modality['descricao'],
                regras: modality['regras'],
                ativo: modality['ativo']))
            .toList() ??
        [];
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    try {
      await _fetchProfileData();
      if (_profileHasChanged()) {
        await _updateCachedProfile();
        hasChanges = true;
      } else {
        hasChanges = false;
      }
      notifyListeners();
    } catch (e) {
      _logger.warning('Erro ao carregar dados do perfil', e);
    }
  }

  bool _profileHasChanged() {
    return !_profilesAreEqual(_originalProfile, _getCurrentProfile());
  }

  Profile _getCurrentProfile() {
    return Profile(
      name: nameController.text,
      nickname: nicknameController.text,
      city: cityController.text,
      phone: phoneController.text,
      classId: int.tryParse(selectedClass ?? ''),
      modalities: selectedModalities.map((m) => m.id!).toList(),
    );
  }

  Future<void> _updateCachedProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String profileJson = json.encode(toJson());
      await prefs.setString('cached_profile', profileJson);
    } catch (e) {
      _logger.warning('Erro ao atualizar perfil no cache', e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nameController.text,
      'nickname': nicknameController.text,
      'city': cityController.text,
      'phone': phoneController.text,
      'classId': selectedClass,
      'modalities': selectedModalities.map((m) => m.id).toList(),
    };
  }

  Future<void> _fetchProfileData() async {
    try {
      final profileData = await apiService.fetchProfile();
      final fetchedClasses = await apiService.fetchClasses();
      final fetchedModalities = await apiService.fetchModalities();

      if (profileData.isNotEmpty) {
        final profile = Profile.fromJson(profileData);

        // Armazena o perfil original para comparações futuras
        _originalProfile = profile;

        // Inicializa os controladores e listas com os dados do perfil
        nameController.text = profile.name ?? '';
        nicknameController.text = profile.nickname ?? '';
        cityController.text = profile.city ?? '';
        phoneController.text = profile.phone ?? '';

        classes = fetchedClasses;
        modalities = fetchedModalities;

        selectedClass = fetchedClasses.any((c) => c.id == profile.classId)
            ? profile.classId.toString()
            : null;

        selectedModalities = profile.modalities?.map((id) {
              return fetchedModalities
                  .firstWhere((modality) => modality.id == id);
            }).toList() ??
            [];
      } else {
        _logger.info('Dados do perfil estão vazios');
      }

      notifyListeners();
    } catch (e) {
      _logger.warning('Erro ao buscar dados do perfil: $e');
    }
  }

  void onModalityChanged(bool selected, int modalityId) {
    if (selected) {
      selectedModalities
          .add(modalities.firstWhere((modality) => modality.id == modalityId));
    } else {
      selectedModalities.removeWhere((modality) => modality.id == modalityId);
    }
    validateForm();
  }

  void validateForm() {
    isFormValid = nameController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        selectedClass != null &&
        selectedModalities.isNotEmpty;
  }

  void updateFormValidation() {
    validateForm();
    notifyListeners();
  }

  Future<void> saveProfile(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      List<int> modalityIds =
          selectedModalities.map((modality) => modality.id!).toList();

      Profile updatedProfile = Profile(
        name: nameController.text,
        nickname: nicknameController.text,
        city: cityController.text,
        phone: phoneController.text,
        classId: int.tryParse(selectedClass!) ?? 0,
        modalities: modalityIds,
      );

      // Verifica se há alterações comparando o perfil original com o atualizado
      if (_profilesAreEqual(_originalProfile, updatedProfile)) {
        ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso')),
        );
        notifyListeners();
        isEditing = false;
        return;
      }

      try {
        bool success = await apiService.updateProfile(updatedProfile);
        if (success) {
          ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso')),
          );
          isEditing = false;
          _originalProfile = updatedProfile; // Atualiza o perfil original
          // Atualiza os valores originais
          _originalName = nameController.text;
          _originalNickname = nicknameController.text;
          _originalCity = cityController.text;
          _originalPhone = phoneController.text;
          _originalClass = selectedClass;
          _originalModalities = List.from(selectedModalities);
        } else {
          _logger.warning('Falha ao atualizar o perfil');
          ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Falha ao atualizar o perfil')),
          );
        }
      } catch (error) {
        _logger.severe('Erro ao atualizar o perfil: $error');
        ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Erro: ${error.toString()}')),
        );
      }

      notifyListeners();
    }
  }

  bool _profilesAreEqual(Profile original, Profile updated) {
    return original.name == updated.name &&
        original.nickname == updated.nickname &&
        original.city == updated.city &&
        original.phone == updated.phone &&
        original.classId == updated.classId &&
        const ListEquality().equals(original.modalities, updated.modalities);
  }

  bool get isEditing => _isEditing;
  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void cancelEditing() {
    _isEditing = false;
    // Restaurar os valores originais dos controladores
    nameController.text = _originalName;
    nicknameController.text = _originalNickname;
    cityController.text = _originalCity;
    phoneController.text = _originalPhone;
    selectedClass = _originalClass;
    selectedModalities = List.from(_originalModalities);
    notifyListeners();
  }

  Future<void> clearUserData() async {
    await apiService.clearToken();
    nameController.clear();
    nicknameController.clear();
    cityController.clear();
    phoneController.clear();
    selectedClass = null;
    selectedModalities.clear();
    classes.clear();
    modalities.clear();
    isFormValid = false;
    isEditing = false;
    modalityError = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_profile');
    notifyListeners();
  }
}
