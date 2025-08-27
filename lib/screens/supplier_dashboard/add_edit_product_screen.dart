import 'dart:math';
import 'package:bonyan/models/product_model.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  const AddEditProductScreen({super.key, this.productId});

  final String? productId;

  @override
  ConsumerState<AddEditProductScreen> createState() =>
      _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEditMode => widget.productId != null;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();

    if (_isEditMode) {
      // In a real app, you would fetch this from a provider.
      // For this mock, we find it in the list.
      final existingProduct = ref
          .read(productsProvider)
          .firstWhere((p) => p.id == widget.productId, orElse: () {
        // This is a fallback, should ideally not happen if IDs are correct.
        return const ProductModel(
            id: '',
            name: 'Not Found',
            price: 0,
            unit: '',
            imageUrl: '',
            supplierId: '',
            supplierName: '',
            description: '');
      });

      _nameController.text = existingProduct.name;
      _descriptionController.text = existingProduct.description;
      _priceController.text = existingProduct.price.toStringAsFixed(0);
      _stockController.text = existingProduct.stock.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenHeader(
        title: _isEditMode ? 'تعديل المنتج' : 'إضافة منتج جديد',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'اسم المنتج',
                hintText: 'مثال: إسمنت مقاوم',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'الوصف',
                hintText: 'أدخل وصفاً للمنتج...',

              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _priceController,
                labelText: 'السعر (بالريال)',
                hintText: '5500',
                keyboardType: TextInputType.number,
                prefixIcon: LucideIcons.dollarSign,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _stockController,
                labelText: 'الكمية المتوفرة (المخزون)',
                hintText: '200',
                keyboardType: TextInputType.number,
                prefixIcon: LucideIcons.package,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: _isEditMode ? 'حفظ التعديلات' : 'إضافة المنتج',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = ProductModel(
        id: _isEditMode ? widget.productId! : Random().nextInt(10000).toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        stock: int.tryParse(_stockController.text) ?? 0,
        // Mocking these values as they are not in the form
        unit: 'للكيس',
        imageUrl: 'https://via.placeholder.com/150',
        supplierId: 'sup-nahda',
        supplierName: 'مؤسسة النهضة للمقاولات',
      );

      if (_isEditMode) {
        ref.read(productsProvider.notifier).editProduct(newProduct);
      } else {
        ref.read(productsProvider.notifier).addProduct(newProduct);
      }

      context.pop();
    }
  }
}
