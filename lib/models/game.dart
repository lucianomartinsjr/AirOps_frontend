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
  });
}
