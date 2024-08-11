class Modality {
  final int id;
  final String descricao;
  final String regras;
  final DateTime criadoEM;
  final bool ativo;

  Modality({
    required this.id,
    required this.descricao,
    required this.regras,
    required this.criadoEM,
    required this.ativo,
  });

  factory Modality.fromJson(Map<String, dynamic> json) {
    return Modality(
      id: json['id'],
      descricao: json['descricao'],
      regras: json['regras'],
      criadoEM: DateTime.parse(json['criadoEM']),
      ativo: json['ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'regras': regras,
      'ativo': ativo,
    };
  }
}
