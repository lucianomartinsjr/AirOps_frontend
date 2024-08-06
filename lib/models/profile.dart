class Profile {
  final String? name;
  final String? nickname;
  final String? city;
  final String? phone;
  final int? classId;
  final List<int>? modalities;

  Profile({
    this.name,
    this.nickname,
    this.city,
    this.phone,
    this.classId,
    this.modalities,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['nome'] as String?,
      nickname: json['apelido'] as String?,
      city: json['cidade'] as String?,
      phone: json['telefone'] as String?,
      classId: json['idClasseOperador'] as int?,
      modalities:
          (json['modalidades'] as List?)?.map((e) => e['id'] as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'apelido': nickname,
      'cidade': city,
      'telefone': phone,
      'idClasseOperador': classId,
      'modalidades': modalities?.map((id) => {'id': id}).toList(),
    };
  }
}
