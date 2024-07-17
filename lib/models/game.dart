import 'players.dart';

class Game {
  final String id;
  final String name;
  final String location;
  final DateTime date;
  final String fieldType;
  final String modality;
  final String period;
  final String organizer;
  final double fee;
  final String imageUrl;
  final String details;
  final String locationLink;
  final List<Player>? players; // Lista de jogadores opcional

  Game({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.fieldType,
    required this.modality,
    required this.period,
    required this.organizer,
    required this.fee,
    required this.imageUrl,
    required this.details,
    required this.locationLink,
    this.players,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    var playersJson = json['players'] as List?;
    List<Player> playersList = playersJson != null
        ? playersJson.map((i) => Player.fromJson(i)).toList()
        : [];

    return Game(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      fieldType: json['fieldType'],
      modality: json['modality'],
      period: json['period'],
      organizer: json['organizer'],
      fee: json['fee'].toDouble(),
      imageUrl: json['imageUrl'],
      details: json['details'],
      locationLink: json['locationLink'],
      players: playersList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? playersJson =
        players?.map((i) => i.toJson()).toList();

    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date.toIso8601String(),
      'fieldType': fieldType,
      'modality': modality,
      'period': period,
      'organizer': organizer,
      'fee': fee,
      'imageUrl': imageUrl,
      'details': details,
      'locationLink': locationLink,
      'players': playersJson,
    };
  }

  int get playersRegistered => players?.length ?? 0;
  int get maxPlayers =>
      22; // ou qualquer outro número dependendo da lógica do seu jogo
}
