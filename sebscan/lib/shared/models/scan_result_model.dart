import 'trigger_model.dart';

class ScanResultModel {
  const ScanResultModel({
    required this.productName,
    required this.brand,
    required this.ingredientsRaw,
    required this.triggers,
    required this.riskScore,
    this.id,
    this.scannedAt,
  });

  final String? id;
  final String productName;
  final String brand;
  final String ingredientsRaw;
  final List<TriggerModel> triggers;
  final int riskScore;
  final DateTime? scannedAt;

  List<String> get cleanIngredients {
    final rawParts = ingredientsRaw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    final triggerNames = triggers.map((item) => item.ingredient).toSet();
    return rawParts
        .where((item) => !triggerNames.any((name) => item.toLowerCase().contains(name)))
        .toList();
  }

  bool get affectsSkin => triggers.any((item) => item.affects.contains(TriggerAffect.skin));

  bool get affectsHair => triggers.any((item) => item.affects.contains(TriggerAffect.hair));

  Map<String, dynamic> toJson(String userId) {
    return {
      'userId': userId,
      'productName': productName,
      'brand': brand,
      'ingredientsRaw': ingredientsRaw,
      'riskScore': riskScore,
      'triggers': triggers.map((item) => item.toJson()).toList(),
      'scannedAt': (scannedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory ScanResultModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return ScanResultModel(
      id: id,
      productName: json['productName'] as String? ?? 'Unknown product',
      brand: json['brand'] as String? ?? 'Unknown brand',
      ingredientsRaw: json['ingredientsRaw'] as String? ?? '',
      riskScore: json['riskScore'] as int? ?? 0,
      triggers: ((json['triggers'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(TriggerModel.fromJson)
          .toList(),
      scannedAt: DateTime.tryParse(json['scannedAt'] as String? ?? ''),
    );
  }
}
