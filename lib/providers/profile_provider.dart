import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/profile.dart';
import '../models/modality.dart';
import '../services/api_service.dart';

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
      print(_fetchProfileData());
      print('Error loading profile data: $e');
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      final profileData = await apiService.fetchProfile();
      final fetchedClasses = await apiService.fetchClasses();
      final fetchedModalities = await apiService.fetchModalities();

      if (profileData.isNotEmpty) {
        final profile = Profile.fromJson(profileData);

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
        print('Profile data is empty');
      }

      notifyListeners();
    } catch (e) {
      print('Error loading profile data: $e');
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
    notifyListeners();
  }

  Future<void> saveProfile(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      // Certifique-se de que selectedModalities contém apenas os IDs das modalidades
      List<int> modalityIds =
          selectedModalities.map((modality) => modality.id).toList();

      Profile updatedProfile = Profile(
        name: nameController.text,
        nickname: nicknameController.text,
        city: cityController.text,
        phone: phoneController.text,
        classId: int.parse(selectedClass!),
        modalities: modalityIds,
      );

      var success = await apiService.updateProfile(updatedProfile);
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
    }
  }

  void toggleEditing() {
    isEditing = !isEditing;
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
    notifyListeners();
  }
}
