import 'package:bonyan/services/auth_service.dart';
import 'package:bonyan/services/storage_service.dart';
import 'package:bonyan/models/user_model.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'dart:io';
import 'package:bonyan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package.flutter_riverpod/flutter_riverpod.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  final String role;

  const CompleteProfileScreen({super.key, required this.role});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _imageFile;

  // Controllers for all potential fields
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _portfolioController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _companyNameController.dispose();
    _productTypeController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _certificationsController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final user = ref.read(userDetailsProvider).asData?.value;
    if (user == null) {
      showErrorSnackBar(context, 'حدث خطأ غير متوقع: لم يتم العثور على المستخدم.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      String? avatarUrl;
      if (_imageFile != null) {
        avatarUrl = await ref
            .read(storageServiceProvider)
            .uploadProfilePicture(uid: user.id, file: _imageFile!);
      }

      final updatedUser = user.copyWith(
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        companyName: _companyNameController.text,
        productType: _productTypeController.text,
        specialization: _specializationController.text,
        yearsOfExperience: int.tryParse(_experienceController.text),
        certifications: _certificationsController.text,
        portfolio: _portfolioController.text,
        isProfileComplete: true,
        avatarUrl: avatarUrl, // This will be null if no image is picked/uploaded
      );

      await ref.read(userActionsProvider).updateUser(updatedUser);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'فشل تحديث الملف الشخصي: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsAsync = ref.watch(userDetailsProvider);

    return userDetailsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('حدث خطأ: ${err.toString()}')),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('لم يتم العثور على المستخدم.')),
          );
        }
        return Scaffold(
          appBar: const ScreenHeader(title: 'إكمال الملف الشخصي'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'مرحباً بك! الرجاء إكمال بياناتك كـ"${widget.role}"',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الحقول المميزة بعلامة * إلزامية',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildImagePicker(),
                  const SizedBox(height: 24),
                  ..._buildFormFields(widget.role),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'حفظ ومتابعة',
                    onPressed: _submit,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null
                ? const Icon(LucideIcons.user, size: 50, color: Colors.grey)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(LucideIcons.camera),
              onPressed: _pickImage,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields(String role) {
    List<Widget> fields = [];

    // Mandatory for all
    fields.addAll([
      CustomTextField(
        controller: _phoneController,
        labelText: 'رقم الهاتف *',
        hintText: 'ادخل رقم هاتفك بالتنسيق اليمني',
        keyboardType: TextInputType.phone,
        prefixIcon: LucideIcons.phone,
        validator: Validators.validateYemeniPhoneNumber,
      ),
      const SizedBox(height: 20),
      CustomTextField(
        controller: _addressController,
        labelText: 'العنوان *',
        hintText: 'ادخل عنوانك',
        prefixIcon: LucideIcons.mapPin,
        validator: (value) => Validators.validateNotEmpty(value, 'العنوان'),
      ),
      const SizedBox(height: 20),
    ]);

    // Role-specific fields
    switch (role) {
      case 'عميل':
        // Client only has the mandatory fields defined above.
        break;
      case 'مورد':
        fields.addAll([
          CustomTextField(
            controller: _companyNameController,
            labelText: 'اسم الشركة (اختياري)',
            hintText: 'ادخل اسم شركتك',
            prefixIcon: LucideIcons.building,
            validator: null, // Optional
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _productTypeController,
            labelText: 'نوع المنتجات (اختياري)',
            hintText: 'مثال: مواد بناء، أدوات كهربائية',
            prefixIcon: LucideIcons.package,
            validator: null, // Optional
          ),
        ]);
        break;
      case 'مهني/مقاول':
        fields.addAll([
          CustomTextField(
            controller: _specializationController,
            labelText: 'التخصص *',
            hintText: 'مثال: سباك، كهربائي',
            prefixIcon: LucideIcons.wrench,
            validator: (value) => Validators.validateNotEmpty(value, 'التخصص'),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _experienceController,
            labelText: 'سنوات الخبرة (اختياري)',
            hintText: 'ادخل عدد سنوات الخبرة',
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.award,
            validator: null, // Optional
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _certificationsController,
            labelText: 'الشهادات (اختياري)',
            hintText: 'اذكر شهاداتك المهنية',
            prefixIcon: LucideIcons.fileText,
            validator: null, // Optional
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _portfolioController,
            labelText: 'سجل الأعمال (اختياري)',
            hintText: 'رابط أو وصف لأعمال سابقة',
            prefixIcon: LucideIcons.briefcase,
            validator: null, // Optional
          ),
        ]);
        break;
    }

    return fields;
  }
}
