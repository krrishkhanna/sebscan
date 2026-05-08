import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/analyzer.dart';
import '../core/utils/risk_score.dart';
import '../features/auth/auth_screen.dart';
import '../features/history/history_screen.dart';
import '../features/home/home_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/results/results_screen.dart';
import '../features/scan/barcode_scan_screen.dart';
import '../features/scan/manual_scan_screen.dart';
import '../features/scan/photo_ocr_screen.dart';
import 'models/scan_result_model.dart';
import 'services/firebase_service.dart';
import 'services/food_facts_service.dart';
import 'widgets/app_shell_scaffold.dart';

final foodFactsServiceProvider = Provider<FoodFactsService>((ref) {
  return FoodFactsService();
});

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

enum ResultsFilter { all, skin, hair }

final resultsFilterProvider = StateProvider<ResultsFilter>((ref) => ResultsFilter.all);

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/learn',
            builder: (context, state) => const LearnScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/scan/manual',
        builder: (context, state) => const ManualScanScreen(),
      ),
      GoRoute(
        path: '/scan/barcode',
        builder: (context, state) => const BarcodeScanScreen(),
      ),
      GoRoute(
        path: '/scan/photo',
        builder: (context, state) => const PhotoOcrScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          final result = state.extra as ScanResultModel?;
          return ResultsScreen(
            result: result ??
                ScanResultModel(
                  productName: 'Preview Result',
                  brand: 'Mock Brand',
                  ingredientsRaw: 'sugar, sunflower oil, yeast extract',
                  triggers: analyzeIngredients('sugar, sunflower oil, yeast extract'),
                  riskScore: getRiskScore(analyzeIngredients('sugar, sunflower oil, yeast extract')),
                ),
          );
        },
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
    ],
  );
});
