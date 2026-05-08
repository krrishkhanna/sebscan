import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/learn')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final avatarLabel = user != null && !user.isAnonymous && (user.email?.isNotEmpty ?? false)
        ? user.email!.trim().substring(0, 1).toUpperCase()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'SebScan',
            style: theme.textTheme.headlineMedium,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              child: avatarLabel == null ? const Icon(Icons.person_outline) : Text(avatarLabel),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexForLocation(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/learn');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
