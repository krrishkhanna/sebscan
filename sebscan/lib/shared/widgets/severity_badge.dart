import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../models/trigger_model.dart';

class SeverityBadge extends StatelessWidget {
  const SeverityBadge({
    required this.severity,
    super.key,
  });

  final TriggerSeverity severity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (severity) {
      TriggerSeverity.high => AppTheme.kColorSeverityHigh,
      TriggerSeverity.medium => AppTheme.kColorSeverityMed,
      TriggerSeverity.low => AppTheme.kColorSeverityLow,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        severity.name.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}
