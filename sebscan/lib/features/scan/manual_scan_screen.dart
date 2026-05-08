import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/analyzer.dart';
import '../../core/utils/risk_score.dart';
import '../../shared/models/scan_result_model.dart';
import '../../shared/providers.dart';

class ManualScanScreen extends ConsumerStatefulWidget {
  const ManualScanScreen({super.key});

  @override
  ConsumerState<ManualScanScreen> createState() => _ManualScanScreenState();
}

class _ManualScanScreenState extends ConsumerState<ManualScanScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    FocusScope.of(context).unfocus();
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() => _loading = true);
    try {
      late final ScanResultModel result;
      if (input.contains(',') || input.toLowerCase().contains('contains')) {
        final triggers = analyzeIngredients(input);
        result = ScanResultModel(
          productName: 'Manual Entry',
          brand: 'Manual',
          ingredientsRaw: input,
          triggers: triggers,
          riskScore: getRiskScore(triggers),
        );
      } else {
        final data = await ref.read(foodFactsServiceProvider).searchByName(input);
        if (data == null || (data['ingredients']?.isEmpty ?? true)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No product match found. Paste ingredients instead.')),
          );
          return;
        }
        final ingredients = data['ingredients'] ?? '';
        final triggers = analyzeIngredients(ingredients);
        result = ScanResultModel(
          productName: data['name'] ?? input,
          brand: data['brand'] ?? 'Unknown brand',
          ingredientsRaw: ingredients,
          triggers: triggers,
          riskScore: getRiskScore(triggers),
        );
      }
      if (mounted) context.push('/results', extra: result);
    } catch (error, stackTrace) {
      debugPrint('Manual analyze failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong while analyzing.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Manual Scan')),
      body: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.72,
        maxChildSize: 0.96,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paste ingredients or product name', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  maxLines: 6,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: 'Paste ingredients or product name',
                    alignLabelWithHint: true,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${_controller.text.length}/500', style: theme.textTheme.bodySmall),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading ? null : _analyze,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Analyze'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
