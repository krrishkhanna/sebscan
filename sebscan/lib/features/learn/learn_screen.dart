import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static const _items = [
    (
      'What is seborrheic dermatitis',
      'Seborrheic dermatitis is a chronic inflammatory skin condition that often flares around the scalp, face, and chest. Food is not the only trigger, but some people notice patterns with certain processed ingredients.',
    ),
    (
      'The gut-skin connection',
      'Gut irritation, blood sugar spikes, and microbiome disruption can amplify inflammatory signals that show up on the skin. That is why SebScan groups many ingredients under gut-related risk.',
    ),
    (
      'Why seed oils inflame skin',
      'Highly processed seed oils tend to be rich in omega-6 fats. In a diet already high in processed foods, that can tilt the inflammatory balance further in the wrong direction.',
    ),
    (
      'DHT dairy and hair fall',
      'Some dairy-heavy foods may increase IGF-1 signaling in sensitive people. Combined with high-inflammatory foods, this can be part of a pattern linked to scalp oiliness and hair shedding.',
    ),
    (
      'What to eat instead',
      'Focus on simpler, whole-food options like fatty fish, leafy greens, olive oil, and berries. These are generally easier to build into an anti-inflammatory routine.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ExpansionTile(
                  title: Text(item.$1, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(item.$2, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on current research. Always consult a dermatologist.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
