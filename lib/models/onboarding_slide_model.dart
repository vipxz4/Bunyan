import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingSlideModel {
  final IconData icon;
  final String title;
  final String text;

  const OnboardingSlideModel({
    required this.icon,
    required this.title,
    required this.text,
  });
}

// Mapping icon names from JS to Lucide Icons
IconData _getIconForName(String name) {
  switch (name) {
    case 'users':
      return LucideIcons.users;
    case 'shopping-cart':
      return LucideIcons.shoppingCart;
    case 'file-check-2':
      return LucideIcons.fileCheck2;
    default:
      return LucideIcons.home;
  }
}

// Mock data based on the HTML
final List<OnboardingSlideModel> onboardingSlidesData = [
  OnboardingSlideModel(
    icon: _getIconForName('users'),
    title: 'اعثر على أفضل المهنيين',
    text: 'تصفح آلاف المهنيين والمقاولين الموثوقين.',
  ),
  OnboardingSlideModel(
    icon: _getIconForName('shopping-cart'),
    title: 'اشترِ مواد البناء بثقة',
    text: 'أفضل المواد من موردين معتمدين مع ضمان الخدمة.',
  ),
  OnboardingSlideModel(
    icon: _getIconForName('file-check-2'),
    title: 'عقود آمنة ومضمونة',
    text: 'نظام عقود إلكتروني يحفظ حقوق جميع الأطراف.',
  ),
];
