import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../app/config/app_config.dart';
import '../../app/routes/app_routes.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  bool _obscurePassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final FormState? state = _formKey.currentState;
    if (state == null || !state.validate()) {
      return;
    }
    if (!_agreeTerms) {
      _showMessage('Anda harus menyetujui syarat & ketentuan.', isError: true);
      return;
    }

    await _runRequest(() async {
      final Response<dynamic> response = await _dio.post<dynamic>(
        '/api/auth/register',
        data: <String, dynamic>{
          'nama': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        },
      );

      _handleAuthResponse(response);
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Gagal' : 'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          isError ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
      colorText: const Color(0xFF0D1B18),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
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

  void _handleAuthResponse(Response<dynamic> response) {
    final dynamic data = response.data;
    if (data is Map<String, dynamic> && data['status'] == true) {
      _showMessage(data['pesan']?.toString() ?? 'Berhasil');
      Get.offAllNamed(RuteAplikasi.login);
      return;
    }
    _showMessage('Terjadi kesalahan', isError: true);
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 6),
                      _HeadlineSection(),
                      const SizedBox(height: 18),
                      _TextFieldBlock(
                        label: 'Nama Lengkap',
                        hint: 'Contoh: Ahmad Fauzi',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (String? value) {
                          final String input = value?.trim() ?? '';
                          if (input.isEmpty) {
                            return 'Nama lengkap wajib diisi';
                          }
                          if (input.length < 3) {
                            return 'Nama minimal 3 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      _TextFieldBlock(
                        label: 'Email',
                        hint: 'fauzi@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
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
                      const SizedBox(height: 8),
                      _PasswordBlock(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      const SizedBox(height: 12),
                      _TermsRow(
                        value: _agreeTerms,
                        onChanged: (bool? value) =>
                            setState(() => _agreeTerms = value ?? false),
                      ),
                      const SizedBox(height: 16),
                      _PrimaryButton(
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),
                      _SwitchLogin(
                        onTap: () => Get.toNamed(RuteAplikasi.login),
                      ),
                      const SizedBox(height: 24),
                      _FooterNote(),
                      const SizedBox(height: 12),
                      const _HomeIndicator(),
                    ],
                  ),
                ),
              ),
            ),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCiwK78rBp_WWxqRH-YG9QkjQtmwKKAxw3TjuPZf9XGhHhfgPxicVcI0Yzlla6_sJOe7PmRMquA91ngr9pM7nadILECeUc5sFexjVZ1_YmcRdV3OIqz5_llRhV0_AQekVWv4DoAscP1NiNc8dEEO7-c19D4lbj293A4J_z6SylQv5_ACV_AiH4diZR43fUZm4QzoBkGTCv9f_cCDjceIRkeduUPLn259pqo-wiIowmV56dJTHfbAwt_zIgjvKcTwtY4Mn0t9Ysxt70',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _HeadlineSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Buat Akun Baru',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B18),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bergabunglah dengan ekosistem finansial Syariah masa kini.',
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

class _TextFieldBlock extends StatelessWidget {
  const _TextFieldBlock({
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    required this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D1B18),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF4C9A88).withOpacity(0.6),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCFE7E2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCFE7E2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF0DA582)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}

class _PasswordBlock extends StatelessWidget {
  const _PasswordBlock({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Kata Sandi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D1B18),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Minimum 8 karakter',
              hintStyle: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF4C9A88).withOpacity(0.6),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCFE7E2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCFE7E2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF0DA582)),
              ),
              suffixIcon: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  obscure ? Symbols.visibility : Symbols.visibility_off,
                  color: const Color(0xFF4C9A88),
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (String? value) {
              final String input = value ?? '';
              if (input.trim().isEmpty) {
                return 'Kata sandi wajib diisi';
              }
              if (input.length < 8) {
                return 'Minimal 8 karakter';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF0DA582),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Saya setuju dengan Syarat & Ketentuan serta Kebijakan Privasi Averroes.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.4,
                color: const Color(0xFF0D1B18),
              ),
            ),
          ),
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
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0DA582),
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: const Color(0x550DA582),
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Daftar'),
                  const SizedBox(width: 8),
                  const Icon(Symbols.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}

class _SwitchLogin extends StatelessWidget {
  const _SwitchLogin({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          'Sudah punya akun? Masuk di sini',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4C9A88),
          ),
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Symbols.verified_user,
            size: 14,
            color: Color(0xFF4C9A88),
          ),
          const SizedBox(width: 6),
          Text(
            'Diawasi oleh OJK & Dewan Syariah Nasional',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF4C9A88),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
