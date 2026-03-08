import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../data/models/domain_model.dart';
import '../../providers/vocmap_provider.dart';

class DomainList extends ConsumerWidget {
  const DomainList({super.key, required this.domains});

  final List<DomainModel> domains;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (domains.isEmpty) {
      return const Center(child: Text('No domains available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: domains.length,
      itemBuilder: (context, i) => _DomainTile(domain: domains[i]),
    );
  }
}

class _DomainTile extends ConsumerWidget {
  const _DomainTile({required this.domain});
  final DomainModel domain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasChildren = domain.children.isNotEmpty;

    if (hasChildren) {
      return ExpansionTile(
        leading: Text(domain.displayIcon, style: const TextStyle(fontSize: 24)),
        title: Text(
          domain.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: domain.wordCount > 0
            ? Text('${domain.wordCount} words',
                style: const TextStyle(color: ChickyColors.textSecondary))
            : null,
        children: domain.children
            .map((child) => _DomainTile(domain: child))
            .toList(),
      );
    }

    return ListTile(
      leading: Text(domain.displayIcon, style: const TextStyle(fontSize: 24)),
      title: Text(domain.name),
      subtitle: domain.wordCount > 0
          ? Text('${domain.wordCount} words',
              style: const TextStyle(color: ChickyColors.textSecondary))
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        ref.read(selectedDomainProvider.notifier).state = domain;
        _showDomainWords(context, domain);
      },
    );
  }

  void _showDomainWords(BuildContext context, DomainModel domain) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _DomainWordsSheet(domain: domain),
    );
  }
}

class _DomainWordsSheet extends ConsumerWidget {
  const _DomainWordsSheet({required this.domain});
  final DomainModel domain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(domainWordsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(domain.displayIcon,
                      style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Text(
                    domain.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: wordsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (words) => ListView.builder(
                  controller: scrollController,
                  itemCount: words.length,
                  itemBuilder: (_, i) {
                    final w = words[i];
                    return ListTile(
                      title: Text(w.word),
                      subtitle: w.primaryDefinition != null
                          ? Text(
                              w.primaryDefinition!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: w.cefrLevel != null
                          ? Chip(
                              label: Text(w.cefrLevel!.toUpperCase()),
                              visualDensity: VisualDensity.compact,
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
