import 'package:bonyan/models/user_model.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;
  UserModel? _initialUser;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _setupController(UserModel user) {
    if (_initialUser == null) {
      _nameController.text = user.fullName;
      _initialUser = user;
    }
  }

  Future<void> _saveChanges() async {
    if (_initialUser == null) return;

    setState(() => _isLoading = true);

    final updatedUser = _initialUser!.copyWith(
      fullName: _nameController.text,
    );

    try {
      await ref.read(userActionsProvider).updateUser(updatedUser);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحديث الملف الشخصي: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userDetailsProvider);

    return Scaffold(
      appBar: const ScreenHeader(title: 'تعديل الملف الشخصي'),
      body: userAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            ErrorDisplayWidget(errorMessage: err.toString()),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('لم يتم العثور على المستخدم.'));
          }
          _setupController(user);

          return SingleChildScrollView(
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
                  controller: _nameController,
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
                  onPressed: _saveChanges,
                  isLoading: _isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
