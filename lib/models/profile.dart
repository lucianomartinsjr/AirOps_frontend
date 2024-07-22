class Profile {
  final String name;
  final String nickname;
  final String city;
  final String phone;
  final String classId;
  final List<int> modalityIds;

  Profile({
    required this.name,
    required this.nickname,
    required this.city,
    required this.phone,
    required this.classId,
    required this.modalityIds,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      nickname: json['nickname'],
      city: json['city'],
      phone: json['phone'],
      classId: json['classId'],
      modalityIds: List<int>.from(json['modalityIds']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nickname': nickname,
      'city': city,
      'phone': phone,
      'className': classId,
      'modalityIds': modalityIds,
    };
  }
}
