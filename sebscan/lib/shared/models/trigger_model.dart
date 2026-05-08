enum TriggerSeverity { high, medium, low }

enum TriggerCategory { gut, inflammatory, hormonal, yeast }

enum TriggerAffect { skin, hair }

class TriggerModel {
  const TriggerModel({
    required this.ingredient,
    required this.severity,
    required this.category,
    required this.reason,
    required this.affects,
  });

  final String ingredient;
  final TriggerSeverity severity;
  final TriggerCategory category;
  final String reason;
  final List<TriggerAffect> affects;

  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient,
      'severity': severity.name,
      'category': category.name,
      'reason': reason,
      'affects': affects.map((item) => item.name).toList(),
    };
  }

  factory TriggerModel.fromJson(Map<String, dynamic> json) {
    return TriggerModel(
      ingredient: json['ingredient'] as String? ?? '',
      severity: TriggerSeverity.values.firstWhere(
        (item) => item.name == json['severity'],
        orElse: () => TriggerSeverity.low,
      ),
      category: TriggerCategory.values.firstWhere(
        (item) => item.name == json['category'],
        orElse: () => TriggerCategory.gut,
      ),
      reason: json['reason'] as String? ?? '',
      affects: ((json['affects'] as List?) ?? const [])
          .map((item) => TriggerAffect.values.firstWhere(
                (value) => value.name == item,
                orElse: () => TriggerAffect.skin,
              ))
          .toList(),
    );
  }
}
