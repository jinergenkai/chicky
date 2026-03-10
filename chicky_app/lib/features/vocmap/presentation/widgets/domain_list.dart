import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/chicky_widgets.dart';
import '../../data/models/domain_model.dart';
import '../../data/models/word_model.dart';
import '../../providers/vocmap_provider.dart';
import 'domain_card.dart';

class DomainList extends ConsumerStatefulWidget {
  const DomainList({super.key, required this.domains});

  final List<DomainModel> domains;

  @override
  ConsumerState<DomainList> createState() => _DomainListState();
}

class _DomainListState extends ConsumerState<DomainList> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showDomainContent(BuildContext context, DomainModel domain) {
    ref.read(selectedDomainProvider.notifier).state = domain;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DomainWordsSheet(domain: domain),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.domains.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No domains available',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 28, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Realms',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Explore the vocabulary universe',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.domains.length,
            itemBuilder: (context, index) {
              final domain = widget.domains[index];
              
              // 3D scaling animation
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                  }
                  
                  return Center(
                    child: Transform.scale(
                      scale: Curves.easeOut.transform(value),
                      child: child,
                    ),
                  );
                },
                child: Center(
                  child: SizedBox(
                    height: 400,
                    width: 250,
                    child: DomainCard(
                      domain: domain,
                      onTap: () => _showDomainContent(context, domain),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Modern Page Indicator
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: ChickyPageDots(
            count: widget.domains.length,
            currentIndex: _currentPage,
          ),
        ),
      ],
    );
  }
}

class _DomainWordsSheet extends ConsumerWidget {
  const _DomainWordsSheet({required this.domain});
  final DomainModel domain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine whether to show sub-domains or words
    final hasChildren = domain.children.isNotEmpty;
    final wordsAsync = hasChildren ? null : ref.watch(domainWordsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Text(domain.displayIcon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      domain.name,
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: hasChildren
                  ? ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: domain.children.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final child = domain.children[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          leading: Text(child.displayIcon, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            child.name, 
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                          ),
                          subtitle: Text(
                            '${child.wordCount} words',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          onTap: () {
                             ref.read(selectedDomainProvider.notifier).state = child;
                             Navigator.pop(context); // Close parent
                             
                             // Delay slightly so the new sheet can open cleanly after closing the old one
                             Future.delayed(const Duration(milliseconds: 100), () {
                                if (context.mounted) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                    ),
                                    builder: (_) => _DomainWordsSheet(domain: child),
                                  );
                                }
                             });
                          },
                        );
                      },
                    )
                  : wordsAsync!.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (words) => ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: words.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final WordModel w = words[i];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            title: Text(
                              w.word,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            subtitle: w.primaryDefinition != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      w.primaryDefinition!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                    ),
                                  )
                                : null,
                            trailing: w.cefrLevel != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      w.cefrLevel!.toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
