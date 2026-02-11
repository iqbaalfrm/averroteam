import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../app/routes/app_routes.dart';
import '../../app/services/auth_service.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF6F8F8).withOpacity(0.9),
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _IconCircleButton(
                    icon: Symbols.arrow_back,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  Text(
                    'Profil Pengguna',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B18),
                    ),
                  ),
                  const _IconCircleButton(icon: Symbols.settings),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _ProfilHero(),
                const SizedBox(height: 16),
                _KontenProfil(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: const Color(0xFF0D1B18)),
      ),
    );
  }
}

class _ProfilHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: -140,
            child: Container(
              width: 420,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFF13ECB9).withOpacity(0.08),
                borderRadius: BorderRadius.circular(260),
              ),
            ),
          ),
          Positioned(
            top: -20,
            child: Opacity(
              opacity: 0.15,
              child: _PolaTitik(),
            ),
          ),
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 132,
                    height: 132,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x3313ECB9),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDFORGYgXC_8HcSiGXC-4wUcjm9UlfKPvukBvZSgOAK62MyJkLIN6rKh4gF3p__OUjgMlU9D3SqllNbOJIAmyYbbzI8jc6xH_Pepc2R7iaxYSzuS2KXmTw1rpgvfziwGcoEvi2GVuB8SXF1tLOsbKFCqtQZofOwG4h1cUPjISOybrf1qK3luFnlfXLgfCfLpwyJtREa0rUz2iySHl7tvyuxgwViFccMeyk9gpn0yyHJf6VOCjireCizNg-_MCIlhsqY5B1lT3mFi4g',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13ECB9),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFF6F8F8), width: 2),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.edit,
                        size: 18,
                        color: Color(0xFF0D1B18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Ahmad Fauzi',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B18),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F3F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'LEVEL 5',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFF4C9A88),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pejuang Syariah',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4C9A88),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _KontenProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          _SectionHeader(
            title: 'Sertifikat Saya',
            action: 'Lihat Semua',
            onTap: () => Get.toNamed(RuteAplikasi.sertifikat),
          ),
          const SizedBox(height: 12),
          _KartuSertifikat(),
          const SizedBox(height: 24),
          _SectionTitle(title: 'Riwayat Pembelajaran'),
          const SizedBox(height: 12),
          _KartuRiwayat(),
          const SizedBox(height: 24),
          _SectionTitle(title: 'Pengaturan Akun'),
          const SizedBox(height: 12),
          _PengaturanList(),
          const SizedBox(height: 20),
          _TombolKeluar(),
          const SizedBox(height: 12),
          Text(
            'Versi Aplikasi 2.4.0',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action, this.onTap});

  final String title;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B18),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF13ECB9),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0D1B18),
        ),
      ),
    );
  }
}

class _KartuSertifikat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFFECFDF5), Color(0xFFCCFBF1)],
              ),
              border: Border.all(color: const Color(0xFFDCFCE7)),
            ),
            child: const Icon(
              Symbols.workspace_premium,
              size: 30,
              color: Color(0xFF4C9A88),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dasar Ekonomi Islam',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B18),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Diselesaikan pada 12 Okt 2023',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    const Icon(
                      Symbols.star,
                      size: 14,
                      color: Color(0xFFEAB308),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Nilai Sempurna',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Symbols.chevron_right,
            color: Color(0xFFCBD5F5),
          ),
        ],
      ),
    );
  }
}

class _KartuRiwayat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13ECB9).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Symbols.school,
                      size: 20,
                      color: Color(0xFF0EB58E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Pengantar Murabahah',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B18),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bab 3 • 15 Menit lagi',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF13ECB9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Lanjut',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.75,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF13ECB9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Progres',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              Text(
                '75%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PengaturanList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: <Widget>[
          _PengaturanItem(
            icon: Symbols.person_outline,
            label: 'Edit Profil',
            onTap: () => Get.toNamed(RuteAplikasi.editProfil),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _PengaturanItem(
            icon: Symbols.notifications_none,
            label: 'Notifikasi',
            onTap: () => Get.toNamed(RuteAplikasi.notifikasi),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _PengaturanItem(
            icon: Symbols.help_outline,
            label: 'Bantuan & Dukungan',
            onTap: () => Get.toNamed(RuteAplikasi.bantuan),
          ),
        ],
      ),
    );
  }
}

class _PengaturanItem extends StatelessWidget {
  const _PengaturanItem({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D1B18),
                ),
              ),
            ),
            const Icon(
              Symbols.chevron_right,
              color: Color(0xFFCBD5F5),
            ),
          ],
        ),
      ),
    );
  }
}

class _TombolKeluar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await AuthService.instance.logout();
        Get.offAllNamed(RuteAplikasi.login);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: Center(
          child: Text(
            'Keluar',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF4444),
            ),
          ),
        ),
      ),
    );
  }
}

class _PolaTitik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 220,
      child: CustomPaint(
        painter: _TitikPainter(),
      ),
    );
  }
}

class _TitikPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF13ECB9)
      ..style = PaintingStyle.fill;

    const double spacing = 24;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
