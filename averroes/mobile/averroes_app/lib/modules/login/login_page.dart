import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../app/config/app_config.dart';
import '../../app/routes/app_routes.dart';
import '../../app/services/auth_service.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginEmailPassword() async {
    if (!_validateForm()) {
      return;
    }

    await _runRequest(() async {
      final Response<dynamic> response = await _dio.post<dynamic>(
        '/api/auth/login',
        data: <String, dynamic>{
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        },
      );

      await _handleAuthResponse(response);
    });
  }

  Future<void> _loginGoogle() async {
    if (!_validateForm()) {
      return;
    }

    await _runRequest(() async {
      final Response<dynamic> response = await _dio.post<dynamic>(
        '/api/auth/google',
        data: <String, dynamic>{
          'email': _emailController.text.trim(),
        },
      );

      await _handleAuthResponse(response);
    });
  }

  Future<void> _loginGuest() async {
    await _runRequest(() async {
      final Response<dynamic> response =
          await _dio.post<dynamic>('/api/auth/guest');
      await _handleAuthResponse(response);
    });
  }

  bool _validateForm() {
    final FormState? state = _formKey.currentState;
    if (state == null) {
      return false;
    }
    return state.validate();
  }

  Future<void> _runRequest(Future<void> Function() action) async {
    if (_isLoading) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await action();
    } on DioException catch (error) {
      final dynamic data = error.response?.data;
      final String message = data is Map<String, dynamic>
          ? (data['pesan']?.toString() ?? 'Terjadi kesalahan')
          : 'Terjadi kesalahan jaringan';
      _showMessage(message, isError: true);
    } catch (_) {
      _showMessage('Terjadi kesalahan', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAuthResponse(Response<dynamic> response) async {
    final dynamic data = response.data;
    if (data is Map<String, dynamic> && data['status'] == true) {
      final Map<String, dynamic>? innerData =
          data['data'] as Map<String, dynamic>?;

      if (innerData != null) {
        final String? token = innerData['token'] as String?;
        final Map<String, dynamic>? user =
            innerData['user'] as Map<String, dynamic>?;

        if (token != null && token.isNotEmpty) {
          await AuthService.instance.simpanAuth(token, user ?? <String, dynamic>{});
          _showMessage(data['pesan']?.toString() ?? 'Berhasil masuk');
          Get.offAllNamed(RuteAplikasi.beranda);
          return;
        }
      }
    }
    _showMessage('Terjadi kesalahan', isError: true);
  }

  void _showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Gagal' : 'Berhasil',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          isError ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
      colorText: const Color(0xFF0D1B18),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Stack(
                  children: <Widget>[
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.08,
                          child: _IslamicPattern(),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 12),
                          _HeaderSection(),
                          const SizedBox(height: 24),
                          _EmailField(controller: _emailController),
                          const SizedBox(height: 16),
                          _PasswordField(
                            controller: _passwordController,
                            obscure: _obscurePassword,
                            onToggle: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            onLupaPassword: () =>
                                Get.toNamed(RuteAplikasi.lupaPassword),
                          ),
                          const SizedBox(height: 18),
                          _PrimaryButton(
                            isLoading: _isLoading,
                            onPressed: _loginEmailPassword,
                          ),
                          const SizedBox(height: 24),
                          _DividerSection(),
                          const SizedBox(height: 12),
                          _GoogleButton(
                            isLoading: _isLoading,
                            onPressed: _loginGoogle,
                          ),
                          const SizedBox(height: 24),
                          _BottomSection(
                            isLoading: _isLoading,
                            onGuestTap: _loginGuest,
                            onRegisterTap: () =>
                                Get.toNamed(RuteAplikasi.register),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Symbols.arrow_back_ios_new,
              size: 20,
              color: Color(0xFF0D1B18),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Symbols.help_outline,
              size: 22,
              color: Color(0xFF0D1B18),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF13ECB9).withAlpha(51),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Symbols.account_balance_wallet,
            color: Color(0xFF13ECB9),
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Masuk ke Akun Anda',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B18),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kelola aset syariah Anda dengan aman dan transparan.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4C9A88),
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Email',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D1B18),
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Masukkan email Anda',
            hintStyle:
                GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF13ECB9)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (String? value) {
            final String input = value?.trim() ?? '';
            if (input.isEmpty) {
              return 'Email wajib diisi';
            }
            if (!input.contains('@') || !input.contains('.')) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.onLupaPassword,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final VoidCallback onLupaPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: <Widget>[
              Text(
                'Password',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D1B18),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onLupaPassword,
                child: Text(
                  'Lupa Password?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF13ECB9),
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Masukkan password',
            hintStyle:
                GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF13ECB9)),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure ? Symbols.visibility : Symbols.visibility_off,
                color: const Color(0xFF94A3B8),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (String? value) {
            final String input = value ?? '';
            if (input.trim().isEmpty) {
              return 'Password wajib diisi';
            }
            if (input.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF13ECB9),
          foregroundColor: const Color(0xFF0D1B18),
          elevation: 6,
          shadowColor: const Color(0x6613ECB9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700, fontSize: 16),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D1B18)),
                ),
              )
            : const Text('Masuk'),
      ),
    );
  }
}

class _DividerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Atau masuk dengan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuB_-Jjq6d8jDWVcG4hBKDQ6uusMSXRVTUtIE2_zxIGlmPuLxxABitBvGrm26_zoYQ84iS4AsvvH6-aukSyreNQ10P8SKxsZHeVGuLqUNNb1Uwkbj7THVip6jP7KfXeoVDdvdYqjSF4P_b47TDFw6GIlUYaKOH_lAZNkCzSxbnyF7IUQgwBfdH_kDivf2MDcJoxAhWLlKvVpH8822pJHPEQrGZEg5skmqHSV2CVlWvClFNZ7ejIHY3I4Ryy1Ulo9pAswHWg9AwHU9ds',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Lanjutkan dengan Google',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D1B18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.isLoading,
    required this.onGuestTap,
    required this.onRegisterTap,
  });

  final bool isLoading;
  final VoidCallback onGuestTap;
  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          onPressed: isLoading ? null : onGuestTap,
          child: Text(
            'Masuk sebagai Tamu',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: isLoading ? null : onRegisterTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Belum punya akun? ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              Text(
                'Daftar Sekarang',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF13ECB9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IslamicPattern extends StatelessWidget {
  const _IslamicPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF13ECB9)
      ..style = PaintingStyle.fill;

    const double spacing = 24;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
