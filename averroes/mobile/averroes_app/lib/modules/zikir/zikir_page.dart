import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HalamanZikir extends StatelessWidget {
  const HalamanZikir({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF6F8F8).withOpacity(0.8),
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
                    'Zikir & Doa',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B18),
                    ),
                  ),
                  const _IconCircleButton(icon: Symbols.search),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Pusat Ketenangan Hati',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D1B18),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Temukan ketenangan dalam setiap kalimat dzikir',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4C9A88),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _KartuUnggulan(),
                  const SizedBox(height: 16),
                  _SearchMini(),
                  const SizedBox(height: 20),
                  Text(
                    'Kategori Utama',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D1B18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ItemKategori(
                    title: 'Dzikir Sholat Fardhu',
                    subtitle: '12/20',
                    progress: 0.6,
                    badge: '60%',
                    icon: Symbols.prayer_times,
                  ),
                  const SizedBox(height: 10),
                  _ItemKategoriSimple(
                    title: 'Doa-Doa Harian',
                    subtitle: 'Makan, Tidur, Bepergian...',
                    trailing: '120 Doa',
                    icon: Symbols.menu_book,
                  ),
                  const SizedBox(height: 10),
                  _ItemKategori(
                    title: 'Asmaul Husna',
                    subtitle: '15/99',
                    progress: 0.15,
                    badge: '99 Nama',
                    icon: Symbols.stars,
                  ),
                  const SizedBox(height: 10),
                  _ItemKategoriSimple(
                    title: 'Zikir Pilihan & Sholawat',
                    subtitle: 'Sholawat Jibril, Nariyah...',
                    trailing: '',
                    icon: Symbols.auto_awesome,
                  ),
                  const SizedBox(height: 24),
                  _HeaderSection(
                    title: 'Edukasi Adab',
                    action: 'Lihat Semua',
                  ),
                  const SizedBox(height: 12),
                  _CarouselAdab(),
                ],
              ),
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
        child: Icon(icon, size: 20, color: const Color(0xFF0D1B18)),
      ),
    );
  }
}

class _KartuUnggulan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(
          child: _KartuUnggulanItem(
            title: 'Dzikir Pagi',
            subtitle: '15 Menit • 24 Doa',
            icon: Symbols.light_mode,
            label: 'Mustajab',
            warna: Color(0xFF0DA582),
            background: Color(0xFFE7F3F0),
            deco: Symbols.temple_hindu,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _KartuUnggulanItem(
            title: 'Dzikir Petang',
            subtitle: '15 Menit • 22 Doa',
            icon: Symbols.dark_mode,
            label: '',
            warna: Color(0xFF0DA582),
            background: Color(0xFFE7F3F0),
            deco: Symbols.mosque,
            showPulse: true,
          ),
        ),
      ],
    );
  }
}

class _KartuUnggulanItem extends StatelessWidget {
  const _KartuUnggulanItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
    required this.warna,
    required this.background,
    required this.deco,
    this.showPulse = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String label;
  final Color warna;
  final Color background;
  final IconData deco;
  final bool showPulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      height: 180,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -8,
            bottom: -8,
            child: Icon(deco, size: 90, color: Colors.white.withOpacity(0.2)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: warna, size: 26),
                  ),
                  if (label.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: warna.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        label.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: warna,
                        ),
                      ),
                    )
                  else if (showPulse)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: warna,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D1B18),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4C9A88),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchMini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Symbols.manage_search,
            size: 20,
            color: Color(0xFF4C9A88),
          ),
          const SizedBox(width: 8),
          Text(
            'Cari doa atau kategori...',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4C9A88),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemKategori extends StatelessWidget {
  const _ItemKategori({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.badge,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final double progress;
  final String badge;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAF5F1)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0DA582)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D1B18),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F3F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0DA582),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCFE7E2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: progress,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0DA582),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4C9A88),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Symbols.chevron_right,
            color: Color(0xFFCBD5F5),
          ),
        ],
      ),
    );
  }
}

class _ItemKategoriSimple extends StatelessWidget {
  const _ItemKategoriSimple({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAF5F1)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0DA582)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D1B18),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4C9A88),
                  ),
                ),
              ],
            ),
          ),
          if (trailing.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  trailing,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Symbols.chevron_right,
                  color: Color(0xFFCBD5F5),
                ),
              ],
            )
          else
            const Icon(
              Symbols.chevron_right,
              color: Color(0xFFCBD5F5),
            ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0D1B18),
          ),
        ),
        Text(
          action,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0DA582),
          ),
        ),
      ],
    );
  }
}

class _CarouselAdab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _AdabCard(
            label: 'FIKIH',
            title: 'Adab-adab Berdoa yang Mustajab',
            icon: Symbols.menu_book,
            warna: Color(0xFFE7F3F0),
          ),
          SizedBox(width: 12),
          _AdabCard(
            label: 'WAKTU UTAMA',
            title: 'Waktu-waktu Terbaik untuk Berdoa',
            icon: Symbols.person_pin_circle,
            warna: Color(0xFFE7F3F0),
          ),
        ],
      ),
    );
  }
}

class _AdabCard extends StatelessWidget {
  const _AdabCard({
    required this.label,
    required this.title,
    required this.icon,
    required this.warna,
  });

  final String label;
  final String title;
  final IconData icon;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAF5F1)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: warna,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Center(
              child: Icon(icon, size: 40, color: const Color(0xFF0DA582).withOpacity(0.4)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0DA582),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
