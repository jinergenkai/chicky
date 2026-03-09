import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/widgets/chicky_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../vocmap/providers/vocmap_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final List<Map<String, String>> _avatarOptions = [
    {'id': 'chicky', 'path': 'assets/avatar/chicky.png', 'label': 'Chicky'},
    {'id': 'foxy', 'path': 'assets/avatar/foxy.png', 'label': 'Foxy'},
    {'id': 'black', 'path': 'assets/avatar/black.png', 'label': 'Blacky'},
    {'id': 'catchy', 'path': 'assets/avatar/catchy.png', 'label': 'Catchy'},
    {'id': 'cozy', 'path': 'assets/avatar/cozy.png', 'label': 'Cozy'},
    {'id': 'buxy', 'path': 'assets/avatar/buxy.png', 'label': 'Buxy'},
    {'id': 'moxy', 'path': 'assets/avatar/moxy.png', 'label': 'Moxy'},
    {'id': 'picky', 'path': 'assets/avatar/picky.png', 'label': 'Picky'},
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



  void _showAvatarPicker(BuildContext context, String currentAvatarVal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Your Avatar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _avatarOptions.length,
                      itemBuilder: (context, index) {
                        final option = _avatarOptions[index];
                        final isSelected = option['id'] == currentAvatarVal;

                        return GestureDetector(
                          onTap: () async {
                            Navigator.pop(ctx);
                            final session = ref.read(authStateProvider).valueOrNull?.session;
                            if (session != null) {
                              try {
                                await Supabase.instance.client.auth.updateUser(
                                  UserAttributes(
                                    data: {
                                      'avatar_url': option['id'],
                                    },
                                  ),
                                );
                                // Ensure provider catches the new session to redraw
                                ref.invalidate(currentUserProvider);
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to update avatar')),
                                  );
                                }
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: isSelected ? Border.all(
                                      color: Theme.of(context).colorScheme.primary, 
                                      width: 4
                                    ) : null,
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      )
                                    ] : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(option['path']!, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                option['label']!,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final supabaseUser = ref.watch(currentUserProvider);
    final appUser = supabaseUser != null ? AppUser.fromSupabaseUser(supabaseUser) : null;
    final vocabStatsAsync = ref.watch(vocabStatsProvider);

    // Get avatar from metadata, fallback to deterministic
    final metadataAvatar = supabaseUser?.userMetadata?['avatar_url'] as String?;
    final avatarId = metadataAvatar ?? 'dog';
    // Find the full path based on ID inside _avatarOptions
    final avatarPath = _avatarOptions.firstWhere(
      (opt) => opt['id'] == avatarId || opt['path']!.contains(avatarId), 
      orElse: () => _avatarOptions[0]
    )['path']!;

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
                                      child: GestureDetector(
                                        onTap: () => _showAvatarPicker(context, avatarId),
                                        child: Container(
                                          width: 140,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                                blurRadius: 32,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(70),
                                                child: Image.asset(
                                                  avatarPath,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder: (_, __, ___) => Image.asset('assets/avatar/black.png', fit: BoxFit.cover),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withValues(alpha: 0.1),
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 2),
                                                      )
                                                    ]
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 16,
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                                ),
                                              )
                                            ],
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
                            Icon(LucideIcons.barChart, color: Theme.of(context).colorScheme.primary, size: 24),
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
