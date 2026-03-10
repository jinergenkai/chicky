import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/onboarding_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/user_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/vocmap/presentation/learn_session_screen.dart';
import 'features/vocmap/presentation/vocmap_screen.dart';
import 'core/theme/theme_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final session = authState.valueOrNull?.session;
      final isLoggedIn = session != null;
      final hasCompletedOnboarding = isLoggedIn &&
          session.user.userMetadata != null &&
          session.user.userMetadata!['display_name'] != null &&
          (session.user.userMetadata!['display_name'] as String)
              .trim()
              .isNotEmpty;

      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      if (isLoggedIn) {
        if (!hasCompletedOnboarding && !isOnboardingRoute) {
          // Force user to onboarding if name isn't set
          return '/onboarding';
        } else if (hasCompletedOnboarding &&
            (isAuthRoute || isOnboardingRoute)) {
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

  ref.listen(authStateProvider, (previous, next) {
    router.refresh();
  });

  return router;
});

/// Exposes a [ValueNotifier<bool>] so child screens can hide/show the bottom bar.
class BottomBarVisibility extends InheritedWidget {
  final ValueNotifier<bool> shouldShow;
  const BottomBarVisibility({
    super.key,
    required this.shouldShow,
    required super.child,
  });

  static ValueNotifier<bool>? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BottomBarVisibility>()
        ?.shouldShow;
  }

  @override
  bool updateShouldNotify(BottomBarVisibility oldWidget) =>
      shouldShow != oldWidget.shouldShow;
}

class _MainShellScaffold extends StatefulWidget {
  final Widget child;
  const _MainShellScaffold({required this.child});

  @override
  State<_MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends State<_MainShellScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final PageController _pageController;
  final ValueNotifier<bool> _shouldShowBar = ValueNotifier(true);
  Timer? _idleTimer;
  bool _isExpanded = true;
  bool _isBarVisible = true;
  int _currentPage = 0;

  // ── Layout constants ──
  static const _expandedHeight = 64.0;
  static const _minimizedHeight = 36.0;
  static const _expandedHPad = 56.0;
  static const _minimizedHPad = 80.0;
  static const _expandedBottom = 16.0;
  static const _minimizedBottom = 8.0;
  static const _idleTimeout = Duration(seconds: 2);

  static final _tabs = [
    _TabConfig(LucideIcons.bookOpen, 'VocMap', '/vocmap'),
    _TabConfig(LucideIcons.messageCircle, 'Chat', '/chat'),
    _TabConfig(LucideIcons.user, 'Profile', '/user'),
  ];

  // The 3 page screens (kept alive via PageView)
  static const _pages = [
    VocMapScreen(),
    ChatScreen(),
    UserScreen(),
  ];

  int _routeToIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/user')) return 2;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _pageController = PageController();
    _shouldShowBar.addListener(_onBarVisibilityChanged);
    _startIdleTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _shouldShowBar.removeListener(_onBarVisibilityChanged);
    _shouldShowBar.dispose();
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onBarVisibilityChanged() {
    final show = _shouldShowBar.value;
    if (show == _isBarVisible) return;
    setState(() => _isBarVisible = show);
    if (!show) {
      // Hide immediately, cancel idle timer
      _idleTimer?.cancel();
    } else {
      _startIdleTimer();
    }
  }

  @override
  void didUpdateWidget(covariant _MainShellScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync PageView when route changes (e.g. from bottom bar tap)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeIndex = _routeToIndex(context);
      if (routeIndex != _currentPage && _pageController.hasClients) {
        _currentPage = routeIndex;
        _pageController.animateToPage(
          routeIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _onPageChanged(int page) {
    if (page != _currentPage) {
      _currentPage = page;
      _resetIdleTimer();
      context.go(_tabs[page].path);
    }
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleTimeout, _minimize);
  }

  void _resetIdleTimer() {
    if (_isExpanded) _startIdleTimer();
  }

  void _expand() {
    if (_isExpanded) return;
    setState(() => _isExpanded = true);
    _animController.animateTo(1.0,
        curve: Curves.elasticOut, duration: const Duration(milliseconds: 500));
    _startIdleTimer();
  }

  void _minimize() {
    if (!_isExpanded) return;
    setState(() => _isExpanded = false);
    _animController.animateTo(0.0,
        curve: Curves.easeOutBack, duration: const Duration(milliseconds: 320));
  }

  void _goToTab(int i) {
    _resetIdleTimer();
    _currentPage = i;
    context.go(_tabs[i].path);
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = _routeToIndex(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Listener(
      onPointerDown: (_) => _resetIdleTimer(),
      child: Scaffold(
        extendBody: true,
        body: BottomBarVisibility(
          shouldShow: _shouldShowBar,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const ClampingScrollPhysics(),
            children: _pages,
          ),
        ),
        bottomNavigationBar: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          offset: _isBarVisible ? Offset.zero : const Offset(0, 1.5),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _isBarVisible ? 1.0 : 0.0,
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                final t = _animController.value;

                final height =
                    _minimizedHeight + (_expandedHeight - _minimizedHeight) * t;
                final hPad =
                    _minimizedHPad + (_expandedHPad - _minimizedHPad) * t;
                final bottom = bottomPadding +
                    _minimizedBottom +
                    (_expandedBottom - _minimizedBottom) * t;
                final radius = 16.0 + 8.0 * t;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: bottom,
                    left: hPad,
                    right: hPad,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragEnd: (details) {
                      final v = details.primaryVelocity ?? 0;
                      if (v < -300) _expand(); // swipe UP on bar → expand
                      if (v > 300) _minimize(); // swipe DOWN on bar → minimize
                    },
                    onTap: () {
                      if (!_isExpanded) {
                        _expand();
                      } else {
                        _resetIdleTimer();
                      }
                    },
                    child: Container(
                      height: height,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.grey.shade50],
                        ),
                        borderRadius: BorderRadius.circular(radius),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(alpha: 0.05 + 0.08 * t),
                            blurRadius: 6 + 18 * t,
                            offset: Offset(0, 2 + 6 * t),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // ── Mini: icon-only tabs ──
                          Opacity(
                            opacity: (1.0 - t * 1.8).clamp(0.0, 1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(_tabs.length, (i) {
                                final selected = i == index;
                                return GestureDetector(
                                  onTap: () => _goToTab(i),
                                  behavior: HitTestBehavior.opaque,
                                  child: SizedBox(
                                    width: 44,
                                    height: 36,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _tabs[i].icon,
                                          size: 17,
                                          color: selected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.grey.shade500,
                                        ),
                                        const SizedBox(height: 2),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: selected ? 6 : 0,
                                          height: selected ? 3 : 0,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          // ── Expanded: full pill tabs ──
                          Opacity(
                            opacity: ((t - 0.35) / 0.65).clamp(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(_tabs.length, (i) {
                                  final selected = i == index;
                                  return GestureDetector(
                                    onTap: () => _goToTab(i),
                                    behavior: HitTestBehavior.opaque,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: selected ? 16 : 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: selected
                                            ? LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ],
                                              )
                                            : null,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: selected
                                            ? [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.3),
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
                                            _tabs[i].icon,
                                            size: 22,
                                            color: selected
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                          ),
                                          if (selected) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              _tabs[i].label,
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
                        ],
                      ),
                    ),
                  ),
                );
              },
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
