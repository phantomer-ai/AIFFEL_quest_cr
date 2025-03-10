class Gecko {
  final String id;
  String name;
  DateTime birthDate;
  String gender;
  String morph;
  DateTime adoptionDate;
  String? imageUrl;
  double weight;

  Gecko({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.morph,
    required this.adoptionDate,
    required this.weight,
    this.imageUrl,
  });

  // 이미지 URL을 업데이트하는 메서드 추가
  Gecko copyWith({String? imageUrl}) {
    return Gecko(
      id: id,
      name: name,
      birthDate: birthDate,
      gender: gender,
      morph: morph,
      adoptionDate: adoptionDate,
      weight: weight,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
