import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/colors.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/user_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/scan/presentation/scan_screen.dart';
import 'features/vocmap/presentation/learn_session_screen.dart';
import 'features/vocmap/presentation/vocmap_screen.dart';
import 'core/theme/theme_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final session = authState.valueOrNull?.session;
      final isLoggedIn = session != null;
      final hasCompletedOnboarding = isLoggedIn &&
          session.user.userMetadata != null &&
          session.user.userMetadata!['display_name'] != null &&
          (session.user.userMetadata!['display_name'] as String).trim().isNotEmpty;

      final isAuthRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      
      if (isLoggedIn) {
        if (!hasCompletedOnboarding && !isOnboardingRoute) {
          // Force user to onboarding if name isn't set
          return '/onboarding';
        } else if (hasCompletedOnboarding && (isAuthRoute || isOnboardingRoute)) {
          // If already onboarded, don't let them go back to login/onboarding manually
          return '/vocmap';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/vocmap',
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/learn',
        builder: (context, state) => const LearnSessionScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Main tabs with floating nav bar ──────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _MainShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/vocmap',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VocMapScreen(),
            ),
          ),
          GoRoute(
            path: '/scan',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScanScreen(),
            ),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: '/user',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UserScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

// ── Main Shell with Floating Nav Bar ────────────────────────────────────

class _MainShellScaffold extends StatelessWidget {
  final Widget child;
  const _MainShellScaffold({required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/scan')) return 1;
    if (location.startsWith('/chat')) return 2;
    if (location.startsWith('/user')) return 3;
    return 0; // vocmap
  }

  static final _tabs = [
    _TabConfig(LucideIcons.bookOpen, 'VocMap', '/vocmap'),
    _TabConfig(LucideIcons.scanLine, 'Scan', '/scan'),
    _TabConfig(LucideIcons.messageCircle, 'Chat', '/chat'),
    _TabConfig(LucideIcons.user, 'Profile', '/user'),
  ];

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 60,
          right: 60,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final selected = i == index;
                return GestureDetector(
                  onTap: () => context.go(tab.path),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                      horizontal: selected ? 16 : 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ChickyColors.primary,
                                ChickyColors.primaryDark,
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: ChickyColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          size: 22,
                          color: selected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        if (selected) ...[
                          const SizedBox(width: 8),
                          Text(
                            tab.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final IconData icon;
  final String label;
  final String path;
  const _TabConfig(this.icon, this.label, this.path);
}

class ChickyApp extends ConsumerWidget {
  const ChickyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeState = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Chicky',
      theme: AppTheme.getLightTheme(themeState.primaryColor),
      darkTheme: AppTheme.getDarkTheme(themeState.primaryColor),
      themeMode: themeState.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

