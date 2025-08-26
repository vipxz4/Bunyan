import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfessionalCard extends StatelessWidget {
  const ProfessionalCard({
    super.key,
    required this.professional,
    this.onTap,
    this.isMini = false,
  });

  final ProfessionalModel professional;
  final VoidCallback? onTap;
  final bool isMini;

  @override
  Widget build(BuildContext context) {
    if (isMini) {
      return _buildMiniCard(context);
    }
    return _buildListCard(context);
  }

  Widget _buildListCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.lightGray,
                backgroundImage: professional.avatarUrl != null
                    ? CachedNetworkImageProvider(professional.avatarUrl!)
                    : null,
                child: professional.avatarUrl == null
                    ? const Icon(LucideIcons.user, color: AppTheme.primary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(professional.name, style: theme.textTheme.titleLarge),
                    Text(
                      professional.specialty,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(LucideIcons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    professional.rating.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCard(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 180,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.lightGray,
                  backgroundImage: professional.avatarUrl != null
                      ? CachedNetworkImageProvider(professional.avatarUrl!)
                      : null,
                  child: professional.avatarUrl == null
                      ? const Icon(LucideIcons.user,
                          size: 30, color: AppTheme.primary)
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  professional.name,
                  style: theme.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.star,
                        color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      professional.rating.toString(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
