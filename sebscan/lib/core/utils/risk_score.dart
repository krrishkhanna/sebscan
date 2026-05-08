import '../../shared/models/trigger_model.dart';

int getRiskScore(List<TriggerModel> triggers) {
  if (triggers.isEmpty) return 0;

  final total = triggers.fold<int>(0, (sum, trigger) {
    switch (trigger.severity) {
      case TriggerSeverity.high:
        return sum + 30;
      case TriggerSeverity.medium:
        return sum + 20;
      case TriggerSeverity.low:
        return sum + 10;
      }
  });

  return total.clamp(0, 100).round();
}
