class Modality {
  final int? id;
  final String descricao;
  final String regras;
  final DateTime? criadoEM;
  final bool ativo;

  Modality({
    this.id,
    required this.descricao,
    required this.regras,
    this.criadoEM,
    required this.ativo,
  });

  factory Modality.fromJson(Map<String, dynamic> json) {
    return Modality(
      id: json['id'] as int?,
      descricao: json['descricao'] as String,
      regras: json['regras'] as String,
      criadoEM:
          json['criadoEM'] != null ? DateTime.parse(json['criadoEM']) : null,
      ativo: json['ativo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'regras': regras,
      'ativo': ativo,
    };
  }

  Modality copyWith({
    int? id,
    String? descricao,
    String? regras,
    DateTime? criadoEM,
    bool? ativo,
  }) {
    return Modality(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      regras: regras ?? this.regras,
      ativo: ativo ?? this.ativo,
    );
  }
}
