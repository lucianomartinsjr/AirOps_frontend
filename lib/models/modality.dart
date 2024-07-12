class Modality {
  final String id;
  final String name;

  Modality({required this.id, required this.name});

  factory Modality.fromJson(Map<String, dynamic> json) {
    return Modality(
      id: json['id'],
      name: json['name'],
    );
  }
}
