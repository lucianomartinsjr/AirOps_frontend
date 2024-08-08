class Player {
  final String nome;
  final String apelido;
  final int idClasseOperador;
  final String contato;
  final String nomeClasse;

  Player({
    required this.nome,
    required this.apelido,
    required this.idClasseOperador,
    required this.contato,
    required this.nomeClasse,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      nome: json['nome'] as String,
      apelido: json['apelido'] as String? ?? '',
      idClasseOperador: json['idClasseOperador'] as int,
      contato: json['contato'] as String? ?? '',
      nomeClasse: json['nomeClasse'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'apelido': apelido,
      'idClasseOperador': idClasseOperador,
      'contato': contato,
      'nomeClasse': nomeClasse,
    };
  }
}
