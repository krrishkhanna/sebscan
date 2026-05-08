import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../shared/providers.dart';
import '../../shared/widgets/scan_option_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scansStream = ref.watch(firebaseServiceProvider).getScans();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Scan for triggers', style: theme.textTheme.displayLarge),
          const SizedBox(height: 8),
          Text(
            'Seborrheic dermatitis and hair fall insights from food labels in seconds.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          ScanOptionCard(
            title: 'Scan Barcode',
            subtitle: 'Point at any packaged food',
            icon: Icons.qr_code_scanner,
            onTap: () => context.push('/scan/barcode'),
          ),
          ScanOptionCard(
            title: 'Photo Scan',
            subtitle: 'Capture or upload a label',
            icon: Icons.document_scanner_outlined,
            onTap: () => context.push('/scan/photo'),
          ),
          ScanOptionCard(
            title: 'Type Ingredients',
            subtitle: 'Paste or search manually',
            icon: Icons.edit_note_outlined,
            onTap: () => context.push('/scan/manual'),
          ),
          const SizedBox(height: 18),
          Text('Recent Scans', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 146,
            child: StreamBuilder(
              stream: scansStream,
              builder: (context, snapshot) {
                final scans = snapshot.data ?? const [];
                if (scans.isEmpty) {
                  return Card(
                    child: Center(
                      child: Text('Your latest saved scans will appear here.', style: theme.textTheme.bodySmall),
                    ),
                  );
                }
                final visible = scans.take(3).toList();
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = visible[index];
                    return SizedBox(
                      width: 220,
                      child: Card(
                        child: InkWell(
                          onTap: () => context.push('/results', extra: item),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                                const Spacer(),
                                Text('Risk ${item.riskScore}', style: theme.textTheme.bodySmall),
                                const SizedBox(height: 4),
                                Text(
                                  item.scannedAt != null ? DateFormat('dd MMM').format(item.scannedAt!) : 'Saved recently',
                                  style: theme.textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
