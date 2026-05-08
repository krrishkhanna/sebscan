import 'package:flutter/material.dart';

class ScanOptionCard extends StatelessWidget {
  const ScanOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
