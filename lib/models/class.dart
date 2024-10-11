class Class {
  final int? id;
  final String nomeClasse;
  final String? descricao;
  final bool? ativo;
  final DateTime? criadoEm;

  Class({
    this.id,
    required this.nomeClasse,
    this.descricao,
    this.ativo,
    this.criadoEm,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      nomeClasse: json['nomeClasse'],
      descricao: json['descricao'],
      criadoEm:
          json['criadoEm'] != null ? DateTime.parse(json['criadoEm']) : null,
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeClasse': nomeClasse,
      'descricao': descricao,
      'ativo': ativo,
    };
  }
}
