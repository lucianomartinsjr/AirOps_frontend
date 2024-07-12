import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/modality.dart';
import '../services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedClass;
  List<String> selectedModalityIds = [];
  List<String> classes = [];
  List<Modality> modalities = [];
  bool isFormValid = false;
  bool isEditing = false;
  String? modalityError;

  late ApiService apiService;

  void initialize(ApiService apiService) {
    this.apiService = apiService;
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      await _fetchProfileData();
    } catch (e) {
      // Tratar erros aqui, se necessário
    }
  }

  Future<void> _fetchProfileData() async {
    var profile = await apiService.fetchProfile();
    var fetchedClasses = await apiService.fetchClasses();
    var fetchedModalities = await apiService.fetchModalities();

    nameController.text = profile.name;
    nicknameController.text = profile.nickname;
    cityController.text = profile.city;
    phoneController.text = profile.phone;
    selectedClass = profile.className;
    selectedModalityIds = profile.modalityIds;
    classes = fetchedClasses;
    modalities = fetchedModalities;

    notifyListeners();
  }

  void onModalityChanged(bool selected, String modalityId) {
    if (selected) {
      selectedModalityIds.add(modalityId);
    } else {
      selectedModalityIds.remove(modalityId);
    }
    validateForm();
  }

  void validateForm() {
    isFormValid = modalityError == null;
    notifyListeners();
  }

  void saveProfile(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() ??
        false && selectedModalityIds.isNotEmpty) {
      Profile updatedProfile = Profile(
        name: nameController.text,
        nickname: nicknameController.text,
        city: cityController.text,
        phone: phoneController.text,
        className: selectedClass!,
        modalityIds: selectedModalityIds,
      );
      apiService.updateProfile(updatedProfile).then((success) {
        if (success) {
          ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso')),
          );
          isEditing = false;
        } else {
          ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Falha ao atualizar o perfil')),
          );
        }
        notifyListeners();
      });
    }
  }

  void toggleEditing() {
    isEditing = !isEditing;
    validateForm();
  }

  Future<void> clearUserData() async {
    await apiService
        .clearToken(); // Método para limpar o token JWT no serviço de API
    nameController.clear();
    nicknameController.clear();
    cityController.clear();
    phoneController.clear();
    selectedClass = null;
    selectedModalityIds.clear();
    classes.clear();
    modalities.clear();
    isFormValid = false;
    isEditing = false;
    modalityError = null;
    notifyListeners();
  }
}
