import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/widgets/chicky_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../vocmap/providers/vocmap_provider.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _avatarScale = 1.0;
  double _headerOpacity = 1.0;

  // Animation controllers for entrance
  late AnimationController _avatarAnimController;
  late AnimationController _nameAnimController;
  late AnimationController _actionsAnimController;
  late AnimationController _contentAnimController;

  late Animation<double> _avatarScaleAnim;
  late Animation<double> _avatarFadeAnim;
  late Animation<Offset> _nameSlideAnim;
  late Animation<double> _nameFadeAnim;
  late Animation<double> _actionsFadeAnim;
  late Animation<double> _contentFadeAnim;

  // List of available avatars in assets/avatar/
  final List<String> _avatars = [
    '4.png', '6.png', 'a.png', 'c.png', 
    'cat.png', 'chuoi.png', 'dog.png', 'luoi.png'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize entrance animations
    _avatarAnimController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _nameAnimController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _actionsAnimController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _contentAnimController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _avatarScaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _avatarAnimController, curve: Curves.elasticOut));
    _avatarFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _avatarAnimController, curve: Curves.easeIn));
    
    _nameSlideAnim = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _nameAnimController, curve: Curves.easeOut));
    _nameFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_nameAnimController);
    _actionsFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_actionsAnimController);
    _contentFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_contentAnimController);

    // Start staggered animations
    Future.delayed(const Duration(milliseconds: 100), () => _avatarAnimController.forward());
    Future.delayed(const Duration(milliseconds: 300), () => _nameAnimController.forward());
    Future.delayed(const Duration(milliseconds: 200), () => _actionsAnimController.forward());
    Future.delayed(const Duration(milliseconds: 500), () => _contentAnimController.forward());

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        _avatarScale = (1.0 - (offset / 200)).clamp(0.6, 1.0);
        _headerOpacity = (1.0 - (offset / 150)).clamp(0.3, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _avatarAnimController.dispose();
    _nameAnimController.dispose();
    _actionsAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  String _getDeterministicAvatar(String userId) {
    int hash = 0;
    for (int i = 0; i < userId.length; i++) {
        hash = userId.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final index = hash.abs() % _avatars.length;
    return 'assets/avatar/${_avatars[index]}';
  }

  @override
  Widget build(BuildContext context) {
    final supabaseUser = ref.watch(currentUserProvider);
    final appUser = supabaseUser != null ? AppUser.fromSupabaseUser(supabaseUser) : null;
    final vocabStatsAsync = ref.watch(vocabStatsProvider);

    final avatarPath = appUser != null ? _getDeterministicAvatar(appUser.id) : 'assets/avatar/dog.png';
    final userName = appUser?.displayName?.isNotEmpty == true ? appUser!.displayName! : 'Learner';

    return Scaffold(
      backgroundColor: ChickyColors.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Modern Header with animated avatar
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        ChickyColors.backgroundLight,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                      child: Column(
                        children: [
                          // Top row with actions
                          FadeTransition(
                            opacity: _actionsFadeAnim,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(LucideIcons.logOut, size: 22, color: Colors.grey.shade700),
                                  onPressed: () {
                                    ref.read(authNotifierProvider.notifier).signOut();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Avatar and name - centered with entrance animations
                          Opacity(
                            opacity: _headerOpacity,
                            child: Column(
                              children: [
                                FadeTransition(
                                  opacity: _avatarFadeAnim,
                                  child: ScaleTransition(
                                    scale: _avatarScaleAnim,
                                    child: AnimatedScale(
                                      scale: _avatarScale,
                                      duration: const Duration(milliseconds: 100),
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: ChickyColors.primary.withOpacity(0.15),
                                              blurRadius: 32,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(70),
                                          child: Image.asset(
                                            avatarPath,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Image.asset('assets/avatar/dog.png', fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FadeTransition(
                                  opacity: _nameFadeAnim,
                                  child: SlideTransition(
                                    position: _nameSlideAnim,
                                    child: Text(
                                      userName,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FadeTransition(
                                  opacity: _nameFadeAnim,
                                  child: SlideTransition(
                                    position: _nameSlideAnim,
                                    child: Text(
                                      appUser?.email ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Main content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _contentFadeAnim,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.barChart, color: ChickyColors.primary, size: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Use stats from provider
                        vocabStatsAsync.when(
                          data: (stats) {
                            final totalLearned = (stats['learning'] ?? 0) + (stats['known'] ?? 0);
                            final totalReviews = stats['known'] ?? 0;
                            // Mock streak and level for now since backend table lacks it
                            final mockStreak = 3;
                            final mockLevel = (totalLearned / 50).floor() + 1;
                            final mockXp = totalLearned * 10;
                            
                            return Column(
                              children: [
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.5,
                                  children: [
                                    ChickyStatsCard(
                                      label: 'Streak',
                                      value: '$mockStreak',
                                      subtitle: 'days',
                                      icon: LucideIcons.flame,
                                      iconColor: Colors.orange,
                                    ),
                                    ChickyStatsCard(
                                      label: 'Words',
                                      value: '$totalLearned',
                                      subtitle: 'learned',
                                      icon: LucideIcons.bookOpen,
                                      iconColor: Colors.blue,
                                    ),
                                    ChickyStatsCard(
                                      label: 'Reviews',
                                      value: '$totalReviews',
                                      subtitle: 'completed',
                                      icon: LucideIcons.repeat,
                                      iconColor: Colors.green,
                                    ),
                                    ChickyStatsCard(
                                      label: 'Level',
                                      value: '$mockLevel',
                                      subtitle: '$mockXp XP',
                                      icon: LucideIcons.trophy,
                                      iconColor: Colors.amber,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // Mastery breakdown
                                Container(
                                  decoration: BoxDecoration(
                                    color: ChickyColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(LucideIcons.pieChart, color: Colors.blueGrey, size: 20),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Mastery Breakdown',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      
                                      _buildMasteryBar('Known', stats['known'] ?? 0, totalLearned, ChickyColors.gradeEasy),
                                      const SizedBox(height: 16),
                                      _buildMasteryBar('Learning', stats['learning'] ?? 0, totalLearned, ChickyColors.gradeHard),
                                      const SizedBox(height: 16),
                                      _buildMasteryBar('New / Unseen', stats['new'] ?? 0, (stats['new'] ?? 0) + totalLearned, Colors.blueGrey.shade300),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const Center(child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(),
                          )),
                          error: (e, _) => Center(child: Text('Error loading stats: $e')),
                        ),
                        
                        const SizedBox(height: 120), // Padding for bottom nav bar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMasteryBar(String title, int value, int total, Color color) {
    if (total == 0) total = 1; // prevent division by zero
    final progress = value / total;
    
    return ChickyProgressBar(
      label: title,
      value: progress,
      color: color,
      height: 10,
    );
  }
}
