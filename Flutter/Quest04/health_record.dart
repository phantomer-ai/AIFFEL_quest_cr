class HealthRecord {
  final String id;
  final String geckoId;
  final DateTime date;
  final String recordType; // 탈피, 건강 체크 등
  final String status; // 정상, 이상 등
  final String? notes; // 특이사항

  HealthRecord({
    required this.id,
    required this.geckoId,
    required this.date,
    required this.recordType,
    required this.status,
    this.notes,
  });
}
