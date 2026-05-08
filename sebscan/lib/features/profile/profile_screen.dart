import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../shared/providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _version = '...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _version = info.version);
      }
    } catch (error, stackTrace) {
      debugPrint('Package info failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(isGuest ? 'Guest' : (user.email ?? 'Guest'), style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          if (isGuest)
            Card(
              child: ListTile(
                title: Text('Sign up to save history across devices', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                subtitle: Text('Create an account to keep your scans synced.', style: theme.textTheme.bodySmall),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/auth'),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Sign out'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await ref.read(firebaseServiceProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Text('App version $_version', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
