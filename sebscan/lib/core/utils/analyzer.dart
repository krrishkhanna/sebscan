import '../../shared/models/trigger_model.dart';
import '../constants/triggers.dart';

List<TriggerModel> analyzeIngredients(String ingredientsText) {
  final input = ingredientsText.toLowerCase();
  final seen = <String>{};
  final matches = <TriggerModel>[];

  for (final trigger in kTriggerDatabase) {
    if (input.contains(trigger.ingredient) && seen.add(trigger.ingredient)) {
      matches.add(trigger);
    }
  }

  matches.sort((a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
  return matches;
}

int _severityRank(TriggerSeverity severity) {
  switch (severity) {
    case TriggerSeverity.high:
      return 3;
    case TriggerSeverity.medium:
      return 2;
    case TriggerSeverity.low:
      return 1;
  }
}
