import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/analyzer.dart';
import '../../core/utils/risk_score.dart';
import '../../shared/models/scan_result_model.dart';
import '../../shared/providers.dart';

class BarcodeScanScreen extends ConsumerStatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  ConsumerState<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends ConsumerState<BarcodeScanScreen> with SingleTickerProviderStateMixin {
  bool _handling = false;
  late final AnimationController _lineController;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(String code) async {
    if (_handling) return;
    _handling = true;

    final data = await ref.read(foodFactsServiceProvider).lookupBarcode(code);
    if (!mounted) return;

    if (data == null || (data['ingredients']?.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Product not found, try manual entry'),
          action: SnackBarAction(
            label: 'Manual',
            onPressed: () => context.push('/scan/manual'),
          ),
        ),
      );
      _handling = false;
      return;
    }

    final ingredients = data['ingredients'] ?? '';
    final triggers = analyzeIngredients(ingredients);
    final result = ScanResultModel(
      productName: data['name'] ?? 'Unknown product',
      brand: data['brand'] ?? 'Unknown brand',
      ingredientsRaw: ingredients,
      triggers: triggers,
      riskScore: getRiskScore(triggers),
    );

    context.pushReplacement('/results', extra: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kColorOverlay,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final code = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
              if (code != null && code.isNotEmpty) {
                _handleBarcode(code);
              }
            },
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ScannerOverlayPainter(),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: AnimatedBuilder(
                animation: _lineController,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(0, (_lineController.value * 2) - 1),
                    child: Container(
                      width: 200,
                      height: 2,
                      color: AppTheme.kColorSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton.filledTonal(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = AppTheme.kColorOverlay.withOpacity(0.58);
    final cutout = Rect.fromCenter(center: size.center(Offset.zero), width: 230, height: 230);

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(16)));
    final combined = Path.combine(PathOperation.difference, path, cutoutPath);
    canvas.drawPath(combined, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
