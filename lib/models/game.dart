import 'players.dart';

class Game {
  final int? id;
  final int? idOperadorOrganizador;
  final String? nomeOrganizador;
  final String cidade;
  final String titulo;
  final DateTime dataEvento;
  final String descricao;
  final double valor;
  final String periodo;
  final String linkCampo;
  final int idModalidadeJogo;
  final String imagemCapa;
  final String? modalidadesJogos;
  final int numMaxOperadores;
  final DateTime? criadoEM;
  final int? quantidadeJogadoresInscritos;
  final List<Player>? players;
  final bool? inscrito;
  final bool? ativo;

  Game({
    this.id,
    this.idOperadorOrganizador,
    this.nomeOrganizador,
    required this.cidade,
    required this.titulo,
    required this.dataEvento,
    required this.descricao,
    required this.valor,
    required this.periodo,
    required this.linkCampo,
    required this.idModalidadeJogo,
    required this.imagemCapa,
    required this.numMaxOperadores,
    this.criadoEM,
    this.quantidadeJogadoresInscritos,
    this.modalidadesJogos,
    this.players,
    this.inscrito,
    this.ativo,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    var playersJson = json['jogadores'] as List?;
    List<Player> playersList = playersJson != null
        ? playersJson
            .map((i) => Player.fromJson(i as Map<String, dynamic>))
            .toList()
        : [];

    return Game(
      id: json['id'] as int?,
      idOperadorOrganizador: json['idOperadorOrganizador'] as int?,
      nomeOrganizador: json['OperadorOrganizador'] as String?,
      cidade: json['cidade'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      dataEvento: json['dataEvento'] != null
          ? DateTime.parse(json['dataEvento'] as String)
          : DateTime.now(), // Valor padrão se estiver ausente
      descricao: json['descricao'] as String? ?? '',
      valor: (json['valor'] as num?)?.toDouble() ??
          0.0, // Trata null e fornece valor padrão
      periodo: json['periodo'] as String? ?? '',
      linkCampo: json['linkCampo'] as String? ?? '',
      idModalidadeJogo: json['idModalidadeJogo'] as int? ?? 0, // Valor padrão
      modalidadesJogos: json['ModalidadesJogos'] as String?,
      imagemCapa: json['imagemCapa'] as String? ?? '',
      numMaxOperadores: json['numMaxOperadores'] as int? ?? 0, // Valor padrão
      criadoEM: json['criadoEM'] != null
          ? DateTime.parse(json['criadoEM'] as String)
          : null,
      quantidadeJogadoresInscritos: json['quantidadeJogadores'] != null
          ? int.tryParse(json['quantidadeJogadores'].toString())
          : null,
      players: playersList,
      inscrito: json['inscrito'] as bool?,
      ativo: json['ativo'] as bool? ?? true, // Valor padrão se estiver ausente
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'dataEvento': dataEvento.toUtc().toIso8601String(),
      'descricao': descricao,
      'cidade': cidade,
      'valor': valor,
      'periodo': periodo,
      'linkCampo': linkCampo,
      'idModalidadeJogo': idModalidadeJogo,
      'numMaxOperadores': numMaxOperadores,
    };
  }
}
