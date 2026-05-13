import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_pbm_2026/models/product_model.dart';
import 'package:tugas_pbm_2026/services/product_service.dart';
import 'package:tugas_pbm_2026/core/utils/dialog_utils.dart';
import 'package:tugas_pbm_2026/core/theme/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ProductService _productService = ProductService();
  bool _isLoading = false;

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final product = Product(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
      );

      final success = await _productService.saveProduct(product);
      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          DialogUtils.showSuccess(
            context,
            'Produk berhasil disimpan',
            onConfirm: () => Navigator.pop(context, true),
          );
        }
      } else {
        if (mounted) DialogUtils.showError(context, 'Gagal menyimpan produk');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorSurface,
      appBar: AppBar(
        title: Text('Tambah Produk', style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
        backgroundColor: AppTheme.colorSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInput('Nama Produk',  'Contoh: iPhone 15 Pro', _nameController, Icons.shopping_bag_outlined),
              const SizedBox(height: 16),
              _buildInput('Harga', 'Contoh: 15000000', _priceController, Icons.payments_outlined, isNumber: true),
              const SizedBox(height: 16),
              _buildInput('Deskripsi', 'Masukkan deskripsi produk', _descriptionController, Icons.description_outlined, maxLines: 3),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.colorOnSurface,
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.text,

          style: GoogleFonts.lexend(),

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: GoogleFonts.lexend(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),

            prefixIcon: Icon(
              icon,
              color: AppTheme.colorPrimary,
            ),

            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppTheme.colorPrimary,
                width: 2,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),

          validator: (value) {

            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }

            if (isNumber &&
                int.tryParse(value) == null) {
              return 'Harga harus berupa angka';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading
        ? null
        : () {
            DialogUtils.showConfirmation(
              context,

              title: 'Simpan Produk',

              message:
                  'Yakin ingin menyimpan produk ini?',

              confirmText: 'Iya',

              onConfirm: _saveProduct,
            );
          },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.colorPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading 
          ? const CircularProgressIndicator()
          : Text('Simpan', style: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
