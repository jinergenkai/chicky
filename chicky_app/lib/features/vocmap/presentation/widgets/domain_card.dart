import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/utils/gradient_utils.dart';
import '../../data/models/domain_model.dart';

class DomainCard extends StatelessWidget {
  const DomainCard({
    super.key,
    required this.domain,
    required this.onTap,
  });

  final DomainModel domain;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // Using slightly less opacity than old app for modern subtle look
              color: Colors.black.withOpacity(0.06), 
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                   RandomGradient(
                    domain.id,
                    seed: "domainCardGradient",
                    child: Container(
                      color: Colors.black.withOpacity(0.15), // Overlay to dim the gradient for text readability
                    ),
                  ),
                ],
              ),
            ),

            // Badge / Icon (top left)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                ),
                child: Row(
                  children: [
                    Text(domain.displayIcon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      domain.children.isNotEmpty ? 'Folder' : 'Domain',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.2
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bookmark icon (top right)
            const Positioned(
              top: 18,
              right: 18,
              child: Icon(
                LucideIcons.bookmark,
                color: Colors.white,
                size: 20,
              ),
            ),

            // Card content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    // Title
                    Text(
                      domain.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            height: 1.2
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),

                    // Stats section 
                    Row(
                      children: [
                        Icon(
                          domain.children.isNotEmpty ? LucideIcons.folderTree : LucideIcons.graduationCap, 
                          color: Colors.white.withOpacity(0.9), 
                          size: 16
                        ),
                        const SizedBox(width: 8),
                        Text(
                          domain.children.isNotEmpty
                              ? '${domain.children.length} sub-domains'
                              : '${domain.wordCount} words',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
