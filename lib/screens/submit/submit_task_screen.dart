import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_pbm_2026/models/product_model.dart';
import 'package:tugas_pbm_2026/services/submit_service.dart';
import 'package:tugas_pbm_2026/core/utils/dialog_utils.dart';
import 'package:tugas_pbm_2026/core/theme/app_theme.dart';

class SubmitTaskScreen extends StatefulWidget {
  final Product product;
  const SubmitTaskScreen({super.key, required this.product});

  @override
  State<SubmitTaskScreen> createState() => _SubmitTaskScreenState();
}

class _SubmitTaskScreenState extends State<SubmitTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _githubController = TextEditingController();
  final SubmitService _submitService = SubmitService();
  bool _isLoading = false;

  Future<void> _submitTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await _submitService.submitTask(widget.product, _githubController.text);
      
      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          DialogUtils.showSuccess(
            context,
            'Tugas Anda telah berhasil disubmit!',
            onConfirm: () => Navigator.pop(context),
          );
        }
      } else {
        if (mounted) DialogUtils.showError(context, 'Gagal mengirim tugas');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorSurface,
      appBar: AppBar(
        title: Text('Submit Tugas', style: GoogleFonts.lexend(fontWeight: FontWeight.bold)),
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
              _buildProductInfoCard(),
              const SizedBox(height: 32),
              _buildGithubInput(),
              const SizedBox(height: 48),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Informasi Produk',

            style: GoogleFonts.lexend(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _buildDetailItem(
            'Nama Produk',
            widget.product.name,
          ),

          const SizedBox(height: 16),

          _buildDetailItem(
            'Harga',
            'Rp ${widget.product.price}',
          ),

          const SizedBox(height: 16),

          _buildDetailItem(
            'Deskripsi',
            widget.product.description,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,

          style: GoogleFonts.lexend(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: AppTheme.colorPrimaryContainer
                .withOpacity(0.08),

            borderRadius: BorderRadius.circular(16),
          ),

          child: Text(
            value,

            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGithubInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Link GitHub', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextFormField(
          controller: _githubController,
          decoration: InputDecoration(
            hintText: 'https://github.com/username/repo',
            filled: true,
            fillColor: const Color(0xFFFFE9E5).withOpacity(0.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Masukkan URL GitHub';
            if (!value.startsWith('https://github.com/')) return 'URL tidak valid';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading
        ? null
        : () {
            DialogUtils.showConfirmation(
              context,

              title: 'Submit Tugas',

              message:
                  'Yakin ingin submit tugas ini?',

              confirmText: 'Submit',

              onConfirm: _submitTask,
            );
          },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.colorPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Submit Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
