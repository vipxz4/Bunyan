import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final nameController = TextEditingController(text: user.fullName);

    return Scaffold(
      appBar: const ScreenHeader(title: 'تعديل الملف الشخصي'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.avatarUrl != null
                      ? CachedNetworkImageProvider(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? const Icon(LucideIcons.user, size: 40)
                      : null,
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: IconButton.filled(
                    onPressed: () {
                      // TODO: Implement image picker
                    },
                    icon: const Icon(LucideIcons.camera, size: 18),
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: nameController,
              labelText: 'الاسم الكامل',
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.phoneNumber,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                fillColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'حفظ التغييرات',
              onPressed: () {
                // TODO: Update user data via provider/repository
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
