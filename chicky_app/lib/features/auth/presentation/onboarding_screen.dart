import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/chicky_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final PageController _buddyPageController;
  final TextEditingController _nameController = TextEditingController();
  int _currentStep = 0;
  String? _selectedAvatar;
  bool _isLoading = false;

  final List<Map<String, String>> _avatarOptions = [
    {'id': '4', 'path': 'assets/avatar/4.png', 'label': 'Buddy'},
    {'id': '6', 'path': 'assets/avatar/6.png', 'label': 'Smarty'},
    {'id': 'a', 'path': 'assets/avatar/a.png', 'label': 'Friendly'},
    {'id': 'c', 'path': 'assets/avatar/c.png', 'label': 'Cool'},
    {'id': 'cat', 'path': 'assets/avatar/cat.png', 'label': 'Kitty'},
    {'id': 'chuoi', 'path': 'assets/avatar/chuoi.png', 'label': 'Banana'},
    {'id': 'dog', 'path': 'assets/avatar/dog.png', 'label': 'Doggy'},
    {'id': 'luoi', 'path': 'assets/avatar/luoi.png', 'label': 'Lazy'}
  ];

  @override
  void initState() {
    super.initState();
    _buddyPageController = PageController(viewportFraction: 0.55);
    _selectedAvatar = _avatarOptions[0]['id'];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buddyPageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();

    if (_currentStep == 4) {
      if (_nameController.text.trim().isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your name')),
        );
        return;
      }
    }

    if (_currentStep < 5) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);
    
    try {
      final name = _nameController.text.trim();
      final avatarId = _selectedAvatar ?? 'dog';
      
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': name,
            'avatar_url': avatarId,
          },
        ),
      );

      if (mounted) {
        // Use go instead of push to prevent going back
        context.go('/vocmap');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: _previousStep,
                      color: ChickyColors.textSecondary,
                    )
                  else
                    const SizedBox(width: 48),

                  const Spacer(),

                  // Step Indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(6, (index) {
                      final isActive = index == _currentStep;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 6,
                        width: isActive ? 16 : 6,
                        decoration: BoxDecoration(
                          color: isActive ? ChickyColors.primary : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content Area - Flexible
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  _buildWelcomeStep(),
                  _buildFeatureStep(
                    icon: LucideIcons.graduationCap,
                    color: ChickyColors.vocabKnown,
                    title: 'Learn Smarter',
                    subtitle: 'Master new vocabulary with smart flashcards tailored to you.',
                  ),
                  _buildFeatureStep(
                    icon: LucideIcons.scanLine,
                    color: ChickyColors.vocabLearning,
                    title: 'Scan Real Text',
                    subtitle: 'Point your camera at any document to instantly extract and learn the vocabulary.',
                  ),
                  _buildFeatureStep(
                    icon: LucideIcons.messageCircle,
                    color: ChickyColors.vocabNew,
                    title: 'Chat with Chicky',
                    subtitle: 'Practice conversation and get instant help from your AI buddy.',
                  ),
                  _buildNameStep(),
                  _buildAvatarStep(),
                ],
              ),
            ),

            // Bottom Action Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : ChickyGradientButton(
                      label: _currentStep == 5 ? 'Get Started' : 'Continue',
                      icon: LucideIcons.arrowRight,
                      onTap: _nextStep,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: ChickyColors.primaryLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.hand, size: 64, color: ChickyColors.primary),
          ),
          const SizedBox(height: 32),
          Text(
            "Hi there!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Welcome to Chicky,\nyour new English companion.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildFeatureStep({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, size: 80, color: color),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              height: 1.4,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ChickyColors.primaryLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.user, size: 48, color: ChickyColors.primary),
            ),
            const SizedBox(height: 32),
            Text(
              "What should we call you?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your Name",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.all(20),
                ),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "This is how Chicky will address you.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStep() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Choose your Buddy",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Swipe to find your perfect match",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 48),

        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _buddyPageController,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            onPageChanged: (index) {
              setState(() => _selectedAvatar = _avatarOptions[index]['id']);
            },
            itemCount: _avatarOptions.length,
            itemBuilder: (context, index) {
              final avatar = _avatarOptions[index];

              return AnimatedBuilder(
                animation: _buddyPageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_buddyPageController.position.haveDimensions) {
                    value = _buddyPageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }

                  return Center(
                    child: Transform.scale(
                      scale: Curves.easeOut.transform(value),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: ChickyColors.primary.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              avatar['path']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          avatar['label']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
