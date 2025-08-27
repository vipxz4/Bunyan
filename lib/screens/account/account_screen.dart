import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/user_model.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, user),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMenuSection([
                    _AccountMenuItem(
                        icon: LucideIcons.user,
                        text: 'تعديل الملف الشخصي',
                        onTap: () => context.push('/account/edit-profile')),
                    _AccountMenuItem(
                        icon: LucideIcons.shoppingBag,
                        text: 'طلبات الشراء',
                        onTap: () => context.push('/account/purchase-orders')),
                    _AccountMenuItem(
                        icon: LucideIcons.mailQuestion,
                        text: 'طلبات عروض الأسعار',
                        onTap: () => context.push('/account/quotation-requests')),
                    _AccountMenuItem(
                        icon: LucideIcons.fileCheck2,
                        text: 'العقود المحفوظة',
                        onTap: () => context.push('/account/saved-contracts')),
                    _AccountMenuItem(
                        icon: LucideIcons.heart,
                        text: 'المفضلة',
                        onTap: () => context.push('/home/favorites')),
                    _AccountMenuItem(
                        icon: LucideIcons.star,
                        text: 'تقييماتي',
                        onTap: () => context.push('/account/my-ratings')),
                  ]),
                  const SizedBox(height: 16),
                  _buildMenuSection([
                    _AccountMenuItem(
                        icon: LucideIcons.settings,
                        text: 'الإعدادات',
                        onTap: () => context.push('/account/settings')),
                    _AccountMenuItem(
                        icon: LucideIcons.helpCircle,
                        text: 'المساعدة والدعم',
                        onTap: () => context.push('/account/help-and-support')),
                  ]),
                  const SizedBox(height: 16),
                  _buildMenuSection([
                    _AccountMenuItem(
                        icon: LucideIcons.briefcase,
                        text: 'لوحة تحكم مقدم الخدمة',
                        color: Colors.green.shade700,
                        onTap: () => context.push('/account/coming-soon')),
                    _AccountMenuItem(
                        icon: LucideIcons.store,
                        text: 'لوحة تحكم المورد',
                        color: Colors.blue.shade700,
                        onTap: () => context.push('/account/coming-soon')),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _showLogoutDialog(context),
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.red.withOpacity(0.1),
                        foregroundColor: AppTheme.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, UserModel user) {
    final textTheme = Theme.of(context).textTheme;
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1517048676732-d65bc937f952?q=80&w=1770&auto=format&fit=crop',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: user.avatarUrl != null
                          ? CachedNetworkImageProvider(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null ? const Icon(LucideIcons.user, size: 40) : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.fullName, style: textTheme.headlineSmall?.copyWith(color: Colors.white)),
                  Text(user.phoneNumber, style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.red),
              child: const Text('تسجيل الخروج'),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
            ),
          ],
        );
      },
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  const _AccountMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.primary),
      title: Text(text, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      trailing: const Icon(LucideIcons.chevronLeft, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}
