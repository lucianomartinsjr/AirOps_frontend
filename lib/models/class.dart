class Class {
  final int id;
  final String nomeClasse;
  final String? descricao;
  final bool? ativo;
  final DateTime? criadoEm;

  Class({
    required this.id,
    required this.nomeClasse,
    this.descricao,
    this.ativo,
    this.criadoEm,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      nomeClasse: json['nomeClasse'],
      descricao: json['descricao'],
      ativo: json['ativo'] != null
          ? json['ativo'] == 'true' || json['ativo'] == true
          : null,
      criadoEm:
          json['criadoEm'] != null ? DateTime.parse(json['criadoEm']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeClasse': nomeClasse,
      'descricao': descricao,
      'ativo': ativo?.toString(),
    };
  }
}
