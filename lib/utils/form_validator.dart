class FormValidator {
  bool isFormValid({
    required String name,
    required String city,
    required String phone,
    required String? selectedClass,
    required List<dynamic> selectedModalities,
  }) {
    return name.isNotEmpty &&
        city.isNotEmpty &&
        phone.isNotEmpty &&
        selectedClass != null &&
        selectedModalities.isNotEmpty;
  }
}