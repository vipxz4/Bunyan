import 'package:bonyan/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(LucideIcons.clipboardList, 'مشاريعي', 0, context),
            _buildNavItem(LucideIcons.home, 'الرئيسية', 1, context),
            _buildNavItem(LucideIcons.user, 'حسابي', 2, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    final bool isSelected = navigationShell.currentIndex == index;
    final Color color = isSelected ? Colors.white : Colors.white.withOpacity(0.6);

    return InkWell(
      onTap: () => _onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
