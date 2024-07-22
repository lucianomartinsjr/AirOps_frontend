class Profile {
  final String name;
  final String nickname;
  final String city;
  final String phone;
  final String classId;
  final List<int> modalityIds;

  Profile({
    required this.name,
    required this.nickname,
    required this.city,
    required this.phone,
    required this.classId,
    required this.modalityIds,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['nome'],
      nickname: json['apelido'],
      city: json['cidade'],
      phone: json['telefone'],
      classId: json['idClasseOperador'],
      modalityIds: List<int>.from(json['modalidades']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'apelido': nickname,
      'cidade': city,
      'telefone': phone,
      'idClasseOperador': classId,
      'modalidades': modalityIds,
    };
  }
}
