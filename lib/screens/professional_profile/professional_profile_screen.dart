import 'package:bunyan/core/app_theme.dart';
import 'package:bunyan/models/models.dart';
import 'package:bunyan/providers/providers.dart';
import 'package:bunyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfessionalProfileScreen extends ConsumerWidget {
  const ProfessionalProfileScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final professionalData = ref.watch(professionalDetailsProvider(id));

    return professionalData.when(
      data: (professional) {
        if (professional == null) {
          return const Scaffold(
            body: Center(child: Text('لم يتم العثور على المهني المطلوب.')),
          );
        }
        // Assuming reviews are fetched separately or part of another provider
        final reviews = ref.watch(myReviewsProvider);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildHeader(context, professional),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: _buildInfoSection(context, professional),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBioSection(context, professional),
                          const SizedBox(height: 24),
                          _buildPortfolioSection(context, professional),
                          const SizedBox(height: 24),
                          _buildReviewsSection(context, reviews),
                          const SizedBox(height: 100), // For bottom nav bar spacing
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: _buildActionButtons(context),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, ProfessionalModel professional) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      actions: [
        Consumer(builder: (context, ref, _) {
          final isFavorite = ref.watch(favoritesProvider
              .select((favs) => favs.professionalIds.contains(id)));
          return IconButton(
            icon: Icon(
                isFavorite ? LucideIcons.heart : LucideIcons.heart,
                color: isFavorite ? AppTheme.red : Colors.white),
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggleProfessionalFavorite(id),
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
          );
        })
      ],
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowRight, color: Colors.white),
        onPressed: () => context.pop(),
        style: IconButton.styleFrom(backgroundColor: Colors.black26),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: professional.backgroundUrl != null
            ? CachedNetworkImage(
                imageUrl: professional.backgroundUrl!,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              )
            : Container(color: AppTheme.primary),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, ProfessionalModel professional) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppTheme.surface,
          child: CircleAvatar(
            radius: 46,
            backgroundImage: professional.avatarUrl != null
                ? CachedNetworkImageProvider(professional.avatarUrl!)
                : null,
            child: professional.avatarUrl == null
                ? const Icon(LucideIcons.user, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(professional.name, style: textTheme.displaySmall),
        Text(professional.specialty, style: textTheme.bodyLarge),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text('${professional.rating} (${professional.reviewCount} تقييم)',
                style: textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (professional.isVerified)
              const _Tag(
                  text: 'تم التحقق منه',
                  icon: LucideIcons.check,
                  color: Colors.green),
            if (professional.acceptsWarrantyPayment) ...[
              const SizedBox(width: 8),
              const _Tag(
                  text: 'يقبل الدفع بالضمان',
                  icon: LucideIcons.shield,
                  color: Colors.blue),
            ]
          ],
        )
      ],
    );
  }

  Widget _buildBioSection(BuildContext context, ProfessionalModel professional) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نبذة تعريفية', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(professional.bio, style: textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildPortfolioSection(BuildContext context, ProfessionalModel professional) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('معرض الأعمال', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: professional.portfolioImageUrls.length > 5 ? 6 : professional.portfolioImageUrls.length,
          itemBuilder: (context, index) {
            if (index == 5) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '+${professional.portfolioImageUrls.length - 5}',
                    style: textTheme.headlineMedium?.copyWith(color: AppTheme.primary),
                  ),
                ),
              );
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: professional.portfolioImageUrls[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ],
    );
  }

   Widget _buildReviewsSection(BuildContext context, List<ReviewModel> reviews) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التقييمات (${reviews.length})', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length > 2 ? 2 : reviews.length, // Show max 2 reviews
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(review.authorName, style: textTheme.titleLarge),
                      Row(
                        children: [
                           const Icon(LucideIcons.star, color: Colors.amber, size: 16),
                           const SizedBox(width: 4),
                           Text(review.rating.toStringAsFixed(1), style: textTheme.titleLarge),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(review.comment, style: textTheme.bodyMedium),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              child: const Text('تواصل'),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
           Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('محمد'),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              child: const Text('طلب عرض سعر'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.icon, required this.color});

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
