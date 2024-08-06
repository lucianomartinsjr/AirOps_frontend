import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  final String nome;
  final String apelido;
  final String idClasseOperador;
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
      nome: json['nome'],
      apelido: json['apelido'],
      idClasseOperador: json['idClasseOperador'],
      contato: json['contato'],
      nomeClasse: json['nomeClasse'],
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
