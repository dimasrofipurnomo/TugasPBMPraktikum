import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_pbm_2026/services/auth_service.dart';
import 'package:tugas_pbm_2026/screens/product/product_list_screen.dart';
import 'package:tugas_pbm_2026/core/utils/dialog_utils.dart';
import 'package:tugas_pbm_2026/core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap masukkan username dan password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final token = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (token != null) {
      if (mounted) {
        DialogUtils.showSuccess(
          context,
          'Selamat datang kembali! Anda berhasil masuk.',
          onConfirm: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        );
      }
    } else {
      if (mounted) {
        DialogUtils.showError(
          context,
          'Login gagal. Periksa kembali NIM dan kata sandi Anda.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorInverseSurface,
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PRODUKMU',
                          style: GoogleFonts.lexend(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Atur dan pantau produk Anda\ndengan lebih praktis dan efisien',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            color: const Color(0xFFFBDCD6).withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.colorSurface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Selamat Datang Kembali',
                      style: GoogleFonts.lexend(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colorOnSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masuk menggunakan NIM Anda',
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        color: AppTheme.colorOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Username Field
                    TextFormField(
                      controller: _usernameController,
                      style: GoogleFonts.lexend(color: AppTheme.colorOnSurface),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: GoogleFonts.lexend(color: AppTheme.colorOnSurfaceVariant),
                        prefixIcon: const Icon(Icons.person_outline, color: AppTheme.colorOnSurfaceVariant),
                        filled: true,
                        fillColor: const Color(0xFFFFE9E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppTheme.colorOutlineVariant, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppTheme.colorOutlineVariant, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppTheme.colorPrimaryContainer, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.lexend(color: AppTheme.colorOnSurface),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.lexend(color: AppTheme.colorOnSurfaceVariant),
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.colorOnSurfaceVariant),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.colorOnSurfaceVariant,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFE9E5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppTheme.colorOutlineVariant, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppTheme.colorOutlineVariant, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppTheme.colorPrimaryContainer, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Login Button
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.colorPrimaryContainer, AppTheme.colorPrimaryFixed],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colorPrimaryContainer.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: AppTheme.colorOnPrimaryContainer,
                                  strokeWidth: 3,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Masuk Sekarang',
                                    style: GoogleFonts.lexend(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.colorOnPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.arrow_forward_rounded, color: AppTheme.colorOnPrimaryContainer),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
