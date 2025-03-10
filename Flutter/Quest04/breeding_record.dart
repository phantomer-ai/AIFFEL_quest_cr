class BreedingRecord {
  final String id;
  final String femaleGeckoId;
  final String? maleGeckoId;
  final DateTime matingDate;
  final DateTime? layingDate;
  final int? eggCount;
  final DateTime? expectedHatchDate;
  final String status; // 교배 중, 산란 완료, 부화 완료 등
  final String? notes;

  BreedingRecord({
    required this.id,
    required this.femaleGeckoId,
    this.maleGeckoId,
    required this.matingDate,
    this.layingDate,
    this.eggCount,
    this.expectedHatchDate,
    required this.status,
    this.notes,
  });
}
