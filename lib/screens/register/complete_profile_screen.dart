import 'package:bonyan/services/auth_service.dart';
import 'package:bonyan/models/user_model.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'package:flutter/material.dart';
import 'package.flutter_riverpod/flutter_riverpod.dart';
import 'package:bonyan/widgets/widgets.dart';
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

  // Controllers for each potential field
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final user = ref.read(userDetailsProvider).asData?.value;
    if (user == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم العثور على المستخدم.')),
      );
      return;
    }

    try {
      final updatedUser = user.copyWith(
        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : user.phoneNumber,
        companyName: _companyNameController.text.isNotEmpty ? _companyNameController.text : user.companyName,
        address: _addressController.text.isNotEmpty ? _addressController.text : user.address,
        specialization: _specializationController.text.isNotEmpty ? _specializationController.text : user.specialization,
        yearsOfExperience: _experienceController.text.isNotEmpty ? int.tryParse(_experienceController.text) : user.yearsOfExperience,
      );

      await ref.read(userActionsProvider).updateUser(updatedUser);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحديث الملف الشخصي: ${e.toString()}')),
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
  }

  List<Widget> _buildFormFields(String role) {
    List<Widget> fields = [];

    // The role names are in Arabic as seen in register_screen.dart
    switch (role) {
      case 'عميل':
        fields.add(
          CustomTextField(
            controller: _phoneController,
            labelText: 'رقم الهاتف',
            hintText: 'ادخل رقم هاتفك',
            keyboardType: TextInputType.phone,
            prefixIcon: LucideIcons.phone,
            validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
          ),
        );
        break;
      case 'مورد':
        fields.addAll([
          CustomTextField(
            controller: _companyNameController,
            labelText: 'اسم الشركة',
            hintText: 'ادخل اسم شركتك',
            prefixIcon: LucideIcons.building,
            validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال اسم الشركة' : null,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _addressController,
            labelText: 'العنوان',
            hintText: 'ادخل عنوان عملك',
            prefixIcon: LucideIcons.mapPin,
            validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال العنوان' : null,
          ),
        ]);
        break;
      case 'مهني/مقاول':
        fields.addAll([
          CustomTextField(
            controller: _specializationController,
            labelText: 'التخصص',
            hintText: 'مثال: سباك، كهربائي',
            prefixIcon: LucideIcons.wrench,
            validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال التخصص' : null,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _experienceController,
            labelText: 'سنوات الخبرة',
            hintText: 'ادخل عدد سنوات الخبرة',
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.award,
            validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال سنوات الخبرة' : null,
          ),
        ]);
        break;
    }

    return fields;
  }
}
