class EnvironmentRecord {
  final String id;
  final String geckoId;
  final DateTime date;
  final double temperature; // 온도 (섭씨)
  final double humidity;    // 습도 (%)
  final String? notes;      // 특이사항

  EnvironmentRecord({
    required this.id,
    required this.geckoId,
    required this.date,
    required this.temperature,
    required this.humidity,
    this.notes,
  });
} 