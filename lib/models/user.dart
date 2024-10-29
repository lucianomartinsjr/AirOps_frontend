class User {
  final int id;
  final int idClasseOperador;
  final String nome;
  final String apelido;
  final String contato;
  final String cidade;
  final String email;
  bool isAdmin;
  final DateTime criadoEm;

  User({
    required this.id,
    required this.idClasseOperador,
    required this.nome,
    required this.apelido,
    required this.contato,
    required this.cidade,
    required this.email,
    required this.isAdmin,
    required this.criadoEm,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      idClasseOperador: json['idClasseOperador'],
      nome: json['nome'],
      apelido: json['apelido'],
      contato: json['contato'],
      cidade: json['cidade'],
      email: json['email'],
      isAdmin: json['isAdmin'],
      criadoEm: DateTime.parse(json['criadoEm']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idClasseOperador': idClasseOperador,
      'nome': nome,
      'apelido': apelido,
      'contato': contato,
      'cidade': cidade,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}
