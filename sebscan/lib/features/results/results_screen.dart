import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/models/scan_result_model.dart';
import '../../shared/models/trigger_model.dart';
import '../../shared/providers.dart';
import 'widgets/risk_gauge.dart';
import 'widgets/trigger_card.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({
    required this.result,
    super.key,
  });

  final ScanResultModel result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filter = ref.watch(resultsFilterProvider);
    final filteredTriggers = switch (filter) {
      ResultsFilter.all => result.triggers,
      ResultsFilter.skin => result.triggers.where((item) => item.affects.contains(TriggerAffect.skin)).toList(),
      ResultsFilter.hair => result.triggers.where((item) => item.affects.contains(TriggerAffect.hair)).toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(result.productName.length > 30 ? '${result.productName.substring(0, 30)}...' : result.productName),
        actions: [
          IconButton(
            tooltip: 'Save scan',
            onPressed: () async {
              await ref.read(firebaseServiceProvider).saveScan(result);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to history')),
                );
              }
            },
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              result.brand,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, color: AppTheme.kColorMuted),
            ),
            const SizedBox(height: 16),
            RiskGauge(score: result.riskScore),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: filter == ResultsFilter.all,
                  onSelected: (_) => ref.read(resultsFilterProvider.notifier).state = ResultsFilter.all,
                ),
                FilterChip(
                  label: const Text('Skin'),
                  selected: filter == ResultsFilter.skin,
                  onSelected: (_) => ref.read(resultsFilterProvider.notifier).state = ResultsFilter.skin,
                ),
                FilterChip(
                  label: const Text('Hair'),
                  selected: filter == ResultsFilter.hair,
                  onSelected: (_) => ref.read(resultsFilterProvider.notifier).state = ResultsFilter.hair,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              itemCount: filteredTriggers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TriggerCard(
                  trigger: filteredTriggers[index],
                  index: index,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${result.cleanIngredients.length} clean ingredients detected',
              style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.kColorSafe),
            ),
            const SizedBox(height: 16),
            Text(
              'Not medical advice. Consult a dermatologist.',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: 11,
                color: AppTheme.kColorMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
