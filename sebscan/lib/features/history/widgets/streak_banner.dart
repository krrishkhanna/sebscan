import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/scan_result_model.dart';

class StreakBanner extends StatelessWidget {
  const StreakBanner({
    required this.scans,
    super.key,
  });

  final List<ScanResultModel> scans;

  int get streak {
    if (scans.isEmpty) return 0;
    final daily = <String, List<ScanResultModel>>{};
    for (final scan in scans) {
      final day = scan.scannedAt?.toIso8601String().split('T').first;
      if (day == null) continue;
      daily.putIfAbsent(day, () => []).add(scan);
    }

    final orderedDays = daily.keys.toList()..sort((a, b) => b.compareTo(a));
    var count = 0;
    for (final day in orderedDays) {
      final dayScans = daily[day] ?? const [];
      if (dayScans.every((scan) => scan.riskScore <= 30)) {
        count += 1;
      } else {
        break;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, color: AppTheme.kColorSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$streak day streak, no high triggers',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
