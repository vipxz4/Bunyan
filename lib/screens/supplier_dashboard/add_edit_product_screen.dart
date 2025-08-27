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

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _unitController = TextEditingController(text: 'للكيس'); // Default value

  ProductModel? _initialProduct;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _setupControllers(ProductModel product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toStringAsFixed(0);
    _stockController.text = product.stock.toString();
    _unitController.text = product.unit;
    _initialProduct = product;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ProductModel?> productAsyncValue = _isEditMode
        ? ref.watch(productDetailsProvider(widget.productId!))
        : const AsyncData(null);

    // Listen to the stream and update controllers when data arrives.
    productAsyncValue.whenData((product) {
      if (product != null && _initialProduct == null) {
        _setupControllers(product);
      }
    });

    return Scaffold(
      appBar: ScreenHeader(
        title: _isEditMode ? 'تعديل المنتج' : 'إضافة منتج جديد',
      ),
      body: productAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (product) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(controller: _nameController, labelText: 'اسم المنتج'),
                  const SizedBox(height: 20),
                  CustomTextField(controller: _descriptionController, labelText: 'الوصف', ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _priceController,
                          labelText: 'السعر',
                          keyboardType: TextInputType.number,
                          prefixIcon: LucideIcons.dollarSign,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          controller: _unitController,
                          labelText: 'الوحدة',
                          hintText: 'مثال: للكيس',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _stockController,
                    labelText: 'الكمية المتوفرة',
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
          );
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(userDetailsProvider).asData?.value;
      if (user == null || user.role != 'مورد') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب أن تكون موردًا لإضافة منتجات.')),
        );
        return;
      }

      final product = ProductModel(
        id: _isEditMode ? widget.productId! : '', // Firestore generates ID on add
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        stock: int.tryParse(_stockController.text) ?? 0,
        unit: _unitController.text,
        imageUrl: _initialProduct?.imageUrl ?? 'https://via.placeholder.com/150', // Keep old or use placeholder
        supplierId: user.id,
        supplierName: user.fullName,
      );

      try {
        final actions = ref.read(productsActionsProvider);
        if (_isEditMode) {
          await actions.editProduct(product);
        } else {
          await actions.addProduct(product);
        }
        context.pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل حفظ المنتج: $e')),
        );
      }
    }
  }
}
