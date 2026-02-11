import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HalamanEditProfil extends StatelessWidget {
  const HalamanEditProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFF8FAFC).withOpacity(0.8),
                elevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _IconCircleButton(
                        icon: Symbols.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      Text(
                        'Edit Profil',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D1B18),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                  child: Column(
                    children: <Widget>[
                      _AvatarEdit(),
                      const SizedBox(height: 24),
                      _FormEdit(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomSimpan(),
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF0D1B18)),
      ),
    );
  }
}

class _AvatarEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: -40,
          child: Opacity(
            opacity: 0.1,
            child: _PolaTitik(),
          ),
        ),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 128,
                  height: 128,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x2213ECB9),
                        blurRadius: 16,
                        offset: Offset(0, 8),
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
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13ECB9),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF8FAFC), width: 3),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x2213ECB9),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Symbols.photo_camera,
                      size: 22,
                      color: Color(0xFF0D1B18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Ubah Foto Profil',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
                color: const Color(0xFF0EB58E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FormEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _FieldInput(
          label: 'NAMA LENGKAP',
          icon: Symbols.person,
          value: 'Ahmad Fauzi',
          hint: 'Masukkan nama lengkap',
        ),
        const SizedBox(height: 16),
        _FieldInput(
          label: 'USERNAME',
          icon: Symbols.alternate_email,
          value: 'ahmadfauzi_id',
          hint: 'Username unik anda',
        ),
        const SizedBox(height: 16),
        _FieldArea(
          label: 'BIO',
          icon: Symbols.description,
          value:
              'Seorang pembelajar yang antusias mendalami ekonomi syariah dan investasi halal untuk masa depan yang lebih berkah.',
          hint: 'Ceritakan sedikit tentang ketertarikan anda pada ekonomi syariah...',
        ),
        const SizedBox(height: 16),
        _FieldInput(
          label: 'NOMOR WHATSAPP',
          icon: Symbols.call,
          value: '+62 812 3456 7890',
          hint: 'Contoh: +62812xxx',
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Nomor ini hanya digunakan untuk koordinasi komunitas.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldInput extends StatelessWidget {
  const _FieldInput({
    required this.label,
    required this.icon,
    required this.value,
    required this.hint,
  });

  final String label;
  final IconData icon;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: const Color(0xFF0EB58E)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value.isEmpty ? hint : value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0D1B18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldArea extends StatelessWidget {
  const _FieldArea({
    required this.label,
    required this.icon,
    required this.value,
    required this.hint,
  });

  final String label;
  final IconData icon;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, color: const Color(0xFF0EB58E)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value.isEmpty ? hint : value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0D1B18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomSimpan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF13ECB9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x2213ECB9),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Simpan Perubahan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D1B18),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Symbols.check_circle,
              color: Color(0xFF0D1B18),
            ),
          ],
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
      height: 140,
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
