import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/models/scan_result_model.dart';
import '../../shared/models/trigger_model.dart';
import '../../shared/providers.dart';
import 'widgets/streak_banner.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: StreamBuilder<List<ScanResultModel>>(
        stream: ref.watch(firebaseServiceProvider).getScans(),
        builder: (context, snapshot) {
          final scans = snapshot.data ?? const <ScanResultModel>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              StreakBanner(scans: scans),
              const SizedBox(height: 16),
              SizedBox(
                height: 240,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: scans.isEmpty
                        ? Center(child: Text('Trigger trends will appear here.', style: theme.textTheme.bodySmall))
                        : BarChart(_buildChartData(scans)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (scans.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No saved scans yet.', style: theme.textTheme.bodySmall),
                  ),
                )
              else
                ...scans.map((scan) {
                  final badgeColor = scan.riskScore <= 30
                      ? AppTheme.kColorSafe
                      : scan.riskScore <= 60
                          ? AppTheme.kColorWarning
                          : AppTheme.kColorDanger;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: ValueKey(scan.id ?? scan.productName),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.kColorDanger.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.delete_outline, color: AppTheme.kColorDanger),
                      ),
                      onDismissed: (_) async {
                        final id = scan.id;
                        if (id != null) {
                          await ref.read(firebaseServiceProvider).deleteScan(id);
                        }
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () => context.push('/results', extra: scan),
                          title: Text(scan.productName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            scan.scannedAt != null ? DateFormat('dd MMM').format(scan.scannedAt!) : 'Saved scan',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: badgeColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Risk ${scan.riskScore}',
                                  style: theme.textTheme.labelMedium?.copyWith(color: badgeColor),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (scan.affectsSkin) const Icon(Icons.face_retouching_natural, size: 16),
                                  if (scan.affectsHair) const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(Icons.content_cut, size: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  BarChartData _buildChartData(List<ScanResultModel> scans) {
    final counts = {
      TriggerCategory.gut: 0,
      TriggerCategory.inflammatory: 0,
      TriggerCategory.hormonal: 0,
      TriggerCategory.yeast: 0,
    };
    for (final scan in scans) {
      for (final trigger in scan.triggers) {
        counts[trigger.category] = (counts[trigger.category] ?? 0) + 1;
      }
    }

    return BarChartData(
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const labels = ['Gut', 'Inflam', 'Horm', 'Yeast'];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(labels[value.toInt()]),
              );
            },
          ),
        ),
      ),
      barGroups: [
        _group(0, counts[TriggerCategory.gut] ?? 0),
        _group(1, counts[TriggerCategory.inflammatory] ?? 0),
        _group(2, counts[TriggerCategory.hormonal] ?? 0),
        _group(3, counts[TriggerCategory.yeast] ?? 0),
      ],
    );
  }

  BarChartGroupData _group(int x, int y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          borderRadius: BorderRadius.circular(6),
          color: AppTheme.kColorPrimary,
          width: 28,
        ),
      ],
    );
  }
}
