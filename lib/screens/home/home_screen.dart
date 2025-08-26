import 'package:bunyan/core/app_theme.dart';
import 'package:bunyan/models/models.dart';
import 'package:bunyan/providers/providers.dart';
import 'package:bunyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProjects = ref.watch(activeProjectsProvider);
    final recommendedProfessionals = ref.watch(recommendedProfessionalsProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, user),
          _buildQuickAccessGrid(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildSearchCards(context),
                ),
                SectionHeader(
                  title: 'مشاريعي النشطة',
                  onViewAll: () {},
                ),
                HorizontalCardCarousel(
                  height: 140,
                  itemCount: activeProjects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(project: activeProjects[index], isMini: true);
                  },
                ),
                SectionHeader(
                  title: 'مهنيون موصى بهم',
                  onViewAll: () {},
                ),
                HorizontalCardCarousel(
                  height: 220,
                  itemCount: recommendedProfessionals.length,
                  itemBuilder: (context, index) {
                    return ProfessionalCard(
                        professional: recommendedProfessionals[index], isMini: true);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, UserModel user) {
    final textTheme = Theme.of(context).textTheme;
    return SliverAppBar(
      backgroundColor: AppTheme.primary,
      expandedHeight: 180.0,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Text(
          'اعثر على مفضلاتك\n من هنا !',
          style: textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white24,
                      backgroundImage: user.avatarUrl != null
                          ? CachedNetworkImageProvider(user.avatarUrl!)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text('أهلاً، ${user.fullName}',
                        style: textTheme.titleLarge?.copyWith(color: Colors.white)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(LucideIcons.bell, color: Colors.white),
                      onPressed: () => context.push('/home/notifications'),
                    ),
                  ],
                ),
                const Spacer(),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(LucideIcons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickAccessButton(
                  icon: LucideIcons.shoppingCart, label: 'سلة التسوق', onTap: () {}),
              _QuickAccessButton(
                  icon: LucideIcons.messageSquare,
                  label: 'الرسائل',
                  onTap: () => context.push('/home/chat')),
              _QuickAccessButton(
                  icon: LucideIcons.heart,
                  label: 'المفضلة',
                  onTap: () => context.push('/home/favorites')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SearchCard(
            title: 'ابحث عن مهني',
            imageUrl: 'https://images.unsplash.com/photo-1599305445671-ac291c9a87bb?q=80&w=1770&auto=format&fit=crop',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SearchCard(
            title: 'ابحث عن مواد',
            imageUrl: 'https://images.unsplash.com/photo-1563461660-63166996d910?q=80&w=1887&auto=format&fit=crop',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Icon(icon, color: AppTheme.primary, size: 28),
                const SizedBox(height: 4),
                Text(label, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(LucideIcons.imageOff)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}
