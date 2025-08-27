import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:bonyan/widgets/widgets.dart';
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
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('لم يتم العثور على المهني المطلوب.')));
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildHeader(context, ref, professional),
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
                          _buildReviewsSection(context, ref, professional.id),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: _buildActionButtons(context, ref, professional.id),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(appBar: AppBar(), body: ErrorDisplayWidget(errorMessage: error.toString())),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, WidgetRef ref, ProfessionalModel professional) {
    final favoriteIds = ref.watch(favoriteProfessionalsProvider);
    final isFavorite = favoriteIds.contains(professional.id);

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      actions: [
        IconButton(
          icon: Icon(isFavorite ? LucideIcons.heart : LucideIcons.heart, color: isFavorite ? AppTheme.red : Colors.white),
          onPressed: () => ref.read(userActionsProvider).toggleProfessionalFavorite(professional.id),
          style: IconButton.styleFrom(backgroundColor: Colors.black26),
        )
      ],
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
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

  Widget _buildReviewsSection(BuildContext context, WidgetRef ref, String professionalId) {
    final reviewsAsyncValue = ref.watch(reviewsForProfessionalProvider(professionalId));
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التقييمات', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        reviewsAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (err, stack) => const Text('لا يمكن تحميل التقييمات.'),
          data: (reviews) {
            if (reviews.isEmpty) {
              return const Text('لا توجد تقييمات لهذا المهني بعد.');
            }
            return ListView.separated(
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
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, String professionalId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              child: const Text('تواصل'),
              onPressed: () async {
                try {
                  final chatId = await ref.read(chatActionsProvider).findOrCreateChat(professionalId);
                  context.push('/home/chat/$chatId');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل بدء المحادثة: $e')));
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              child: const Text('طلب عرض سعر'),
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('هذه الميزة غير متوفرة بعد.')),
                );
              },
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
