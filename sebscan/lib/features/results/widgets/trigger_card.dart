import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/trigger_model.dart';
import '../../../shared/widgets/severity_badge.dart';

class TriggerCard extends StatefulWidget {
  const TriggerCard({
    required this.trigger,
    required this.index,
    super.key,
  });

  final TriggerModel trigger;
  final int index;

  @override
  State<TriggerCard> createState() => _TriggerCardState();
}

class _TriggerCardState extends State<TriggerCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get severityColor {
    switch (widget.trigger.severity) {
      case TriggerSeverity.high:
        return AppTheme.kColorSeverityHigh;
      case TriggerSeverity.medium:
        return AppTheme.kColorSeverityMed;
      case TriggerSeverity.low:
        return AppTheme.kColorSeverityLow;
    }
  }

  ({Color background, Color text, String emoji, String label}) get categoryStyle {
    switch (widget.trigger.category) {
      case TriggerCategory.gut:
        return (background: AppTheme.kCategoryGutBg, text: AppTheme.kCategoryGutText, emoji: '🦠', label: 'Gut');
      case TriggerCategory.inflammatory:
        return (background: AppTheme.kCategoryInflammatoryBg, text: AppTheme.kCategoryInflammatoryText, emoji: '🔥', label: 'Inflammatory');
      case TriggerCategory.hormonal:
        return (background: AppTheme.kCategoryHormonalBg, text: AppTheme.kCategoryHormonalText, emoji: '⚡', label: 'Hormonal');
      case TriggerCategory.yeast:
        return (background: AppTheme.kCategoryYeastBg, text: AppTheme.kCategoryYeastText, emoji: '⚠️', label: 'Yeast');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = categoryStyle;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.kColorWhite,
            border: Border.all(color: AppTheme.kColorBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.trigger.ingredient,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppTheme.kColorTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.trigger.reason,
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, color: AppTheme.kColorMuted),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Pill(
                            label: '${category.emoji} ${category.label}',
                            backgroundColor: category.background,
                            textColor: category.text,
                          ),
                          SeverityBadge(severity: widget.trigger.severity),
                          for (final affect in widget.trigger.affects)
                            _Pill(
                              label: affect == TriggerAffect.skin ? 'Skin' : 'Hair',
                              backgroundColor: AppTheme.kColorBorder,
                              textColor: AppTheme.kColorTextPrimary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }
}
