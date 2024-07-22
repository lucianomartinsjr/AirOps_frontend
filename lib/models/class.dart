class Class {
  final String id;
  final String nomeClasse;
  final String descricao;
  final String ativo;
  final String criadoEm;

  Class({
    required this.id,
    required this.nomeClasse,
    required this.descricao,
    required this.ativo,
    required this.criadoEm,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      nomeClasse: json['nomeClasse'],
      descricao: json['descricao'],
      ativo: json['ativo'],
      criadoEm: json['criadoEm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeClasse': nomeClasse,
      'descricao': descricao,
      'ativo': ativo,
      'criadoEm': criadoEm,
    };
  }
}
