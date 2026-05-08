import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/analyzer.dart';
import '../../core/utils/risk_score.dart';
import '../../shared/models/scan_result_model.dart';

class PhotoOcrScreen extends ConsumerStatefulWidget {
  const PhotoOcrScreen({super.key});

  @override
  ConsumerState<PhotoOcrScreen> createState() => _PhotoOcrScreenState();
}

class _PhotoOcrScreenState extends ConsumerState<PhotoOcrScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _recognizer = TextRecognizer();
  XFile? _image;
  bool _loading = false;

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source);
      if (file == null) return;
      setState(() {
        _image = file;
      });
      await _process(file);
    } catch (error, stackTrace) {
      debugPrint('Image pick failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open that image right now.')),
        );
      }
    }
  }

  Future<void> _process(XFile file) async {
    setState(() => _loading = true);
    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final recognized = await _recognizer.processImage(inputImage);
      final text = recognized.text.trim();
      if (text.length > 30) {
        final triggers = analyzeIngredients(text);
        final result = ScanResultModel(
          productName: 'Photo Scan',
          brand: 'OCR Extracted',
          ingredientsRaw: text,
          triggers: triggers,
          riskScore: getRiskScore(triggers),
        );
        if (mounted) {
          context.push('/results', extra: result);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not read label clearly, try manual entry'),
            action: SnackBarAction(
              label: 'Manual',
              onPressed: () => context.push('/scan/manual'),
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      debugPrint('OCR failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not process this image.')),
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
      appBar: AppBar(title: const Text('Photo OCR')),
      body: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.65,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Capture a food label', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                if (_image != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_image!.path),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_loading) const LinearProgressIndicator(),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading ? null : () => _pick(ImageSource.camera),
                    child: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _loading ? null : () => _pick(ImageSource.gallery),
                    child: const Text('Upload'),
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
