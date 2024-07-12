class Profile {
  final String name;
  final String nickname;
  final String city;
  final String phone;
  final String className;
  final List<String> modalityIds;

  Profile({
    required this.name,
    required this.nickname,
    required this.city,
    required this.phone,
    required this.className,
    required this.modalityIds,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      nickname: json['nickname'],
      city: json['city'],
      phone: json['phone'],
      className: json['className'],
      modalityIds: List<String>.from(json['modalityIds']),
    );
  }
}
