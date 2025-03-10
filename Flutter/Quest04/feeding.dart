class Feeding {
  final String id;
  final String geckoId;
  final DateTime date;
  final String foodType; // 파우더, 곤충 등
  final double amount; // 파우더의 경우 g, 곤충의 경우 마리 수
  final String? notes; // 특이사항

  Feeding({
    required this.id,
    required this.geckoId,
    required this.date,
    required this.foodType,
    required this.amount,
    this.notes,
  });
}
