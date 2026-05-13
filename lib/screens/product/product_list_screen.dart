import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_pbm_2026/models/product_model.dart';
import 'package:tugas_pbm_2026/services/auth_service.dart';
import 'package:tugas_pbm_2026/services/product_service.dart';
import 'package:tugas_pbm_2026/core/constants/app_constants.dart';
import 'package:tugas_pbm_2026/core/utils/dialog_utils.dart';
import 'package:tugas_pbm_2026/core/theme/app_theme.dart';
import 'package:tugas_pbm_2026/screens/product/add_product_screen.dart';
import 'package:tugas_pbm_2026/screens/submit/submit_task_screen.dart';
import 'package:tugas_pbm_2026/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _userName = 'Pengguna';
  final _searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString(AppConstants.usernameKey) ?? 'Pengguna';
    });
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final products = await _productService.getProducts();
    if (!mounted) return;
    setState(() {
      _products = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _logout() async {
    DialogUtils.showConfirmation(
      context,
      title: 'Konfirmasi Keluar',
      message: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Keluar',
      isDestructive: true,
      onConfirm: () async {
        await _authService.logout();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
    );
  }

  Future<void> _deleteProduct(Product product) async {

    DialogUtils.showConfirmation(
      context,

      title: 'Hapus Produk',

      message:
          'Yakin ingin menghapus produk ini?',

      confirmText: 'Hapus',

      isDestructive: true,

      onConfirm: () async {

        final success =
            await _productService.deleteProduct(
          product.id!,
        );

        if (!mounted) return;

        if (success) {

          _loadProducts();

          DialogUtils.showSuccess(
            context,
            'Produk berhasil dihapus',
          );
        } else {

          DialogUtils.showError(
            context,
            'Gagal menghapus produk',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorSurface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.colorPrimaryContainer.withOpacity(0.2),
                    child: const Icon(Icons.person, color: AppTheme.colorPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo,', style: GoogleFonts.lexend(fontSize: 14, color: AppTheme.colorOnSurfaceVariant)),
                        Text(_userName, style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.colorOnSurface)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts,
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFFFE9E5).withOpacity(0.5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // Product List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadProducts,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildBanner(),
                      const SizedBox(height: 24),
                      Text('Katalog Produk', style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredProducts.isEmpty
                              ? _buildEmptyState()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _filteredProducts.length,

                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 14),

                                  itemBuilder: (context, index) {
                                    return _buildProductCard(
                                      _filteredProducts[index],
                                    );
                                  },
                                ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
          if (result == true) _loadProducts();
        },
        backgroundColor: AppTheme.colorPrimaryContainer,
        child: const Icon(Icons.add, color: AppTheme.colorOnPrimaryContainer),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  product.name,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  currencyFormat.format(product.price),

                  style: GoogleFonts.lexend(
                    color: AppTheme.colorPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {
              _showProductDetail(product);
            },

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppTheme.colorPrimary,

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),

            child: Text(
              'Detail',

              style: GoogleFonts.lexend(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetail(Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      builder: (_) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              40,
            ),

            decoration: const BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Center(
                  child: Container(
                    width: 60,
                    height: 6,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,

                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  product.name,

                  style: GoogleFonts.lexend(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  currencyFormat.format(product.price),

                  style: GoogleFonts.lexend(
                    fontSize: 20,
                    color: AppTheme.colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Deskripsi Produk',

                  style: GoogleFonts.lexend(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  product.description,

                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  children: [

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {

                          Navigator.pop(context);

                          _deleteProduct(product);
                        },

                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,

                          side: const BorderSide(
                            color: Colors.redAccent,
                          ),

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 18,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),

                        child: Text(
                          'Hapus',

                          style: GoogleFonts.lexend(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SubmitTaskScreen(
                                product: product,
                              ),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.colorPrimary,

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 18,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),

                        child: Text(
                          'Submit',

                          style: GoogleFonts.lexend(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7B4E38), Color(0xFF5C3A29)]), borderRadius: BorderRadius.circular(20)),
      child: const Text('Kelola daftar produk Anda\ndengan mudah di sini', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Tidak ada produk ditemukan')));
  }
}
