import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:averroes_core/averroes_core.dart';

class HalamanPustaka extends StatelessWidget {
  const HalamanPustaka({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _IconButtonCard(
                        icon: Symbols.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pustaka',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Koleksi Digital',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const _IconButtonCard(
                    icon: Symbols.search_rounded,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _KategoriPustaka(),
                  const SizedBox(height: 24),
                  _BannerUnggulan(),
                  const SizedBox(height: 24),
                  _JudulBagian(
                    judul: 'Koleksi Terbaru',
                    aksi: 'Lihat Semua',
                  ),
                  const SizedBox(height: 16),
                  _KartuDokumen(
                    judul: 'Fatwa DSN-MUI tentang Kripto',
                    tag: 'Fatwa MUI',
                    info: '2024',
                    icon: Symbols.description,
                    warnaIcon: const Color(0xFFE0F2FE),
                    warnaTag: const Color(0xFF0EA5E9),
                  ),
                  const SizedBox(height: 16),
                  _KartuDokumen(
                    judul: 'Buku Saku Zakat Praktis',
                    tag: 'E-Book',
                    info: '1.8 MB',
                    icon: Symbols.menu_book,
                    warnaIcon: const Color(0xFFFEF3C7),
                    warnaTag: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 16),
                  _KartuDokumen(
                    judul: 'Fatwa E-Wallet Syariah',
                    tag: 'Regulasi',
                    info: 'Gratis',
                    icon: Symbols.verified_user,
                    warnaIcon: const Color(0xFFD1FAE5),
                    warnaTag: const Color(0xFF059669),
                  ),
                  const SizedBox(height: 16),
                  _KartuDokumen(
                    judul: 'Glosarium Muamalah 2024',
                    tag: 'Premium',
                    info: 'Segera',
                    icon: Symbols.local_library,
                    warnaIcon: const Color(0xFFFFE4E6),
                    warnaTag: const Color(0xFFFB7185),
                    nonAktif: true,
                  ),
                  const SizedBox(height: 24),
                  _KartuPermintaan(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButtonCard extends StatelessWidget {
  const _IconButtonCard({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
      ),
    );
  }
}

class _KategoriPustaka extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_ChipKategori> kategori = <_ChipKategori>[
      _ChipKategori(
        label: 'Semua',
        icon: Symbols.grid_view,
        aktif: true,
      ),
      _ChipKategori(
        label: 'Fatwa MUI',
        icon: Symbols.account_balance,
        warnaIcon: const Color(0xFFF59E0B),
      ),
      _ChipKategori(
        label: 'E-Book',
        icon: Symbols.auto_stories,
        warnaIcon: const Color(0xFF0EA5E9),
      ),
      _ChipKategori(
        label: 'Regulasi',
        icon: Symbols.gavel,
        warnaIcon: const Color(0xFF10B981),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kategori
            .map(
              (_ChipKategori item) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _ChipKategoriWidget(item: item),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ChipKategoriWidget extends StatelessWidget {
  const _ChipKategoriWidget({required this.item});

  final _ChipKategori item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: item.aktif ? const Color(0xFF065F46) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: item.aktif
            ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x33064E3B),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : const <BoxShadow>[
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
      ),
      child: Row(
        children: <Widget>[
          Icon(
            item.icon,
            size: 16,
            color: item.aktif ? Colors.white : (item.warnaIcon ?? const Color(0xFF64748B)),
          ),
          const SizedBox(width: 8),
          Text(
            item.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: item.aktif ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerUnggulan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF065F46),
            Color(0xFF059669),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33064E3B),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white30),
                ),
                child: Text(
                  'Unggulan Bulan Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Panduan Investasi Kripto Syariah 2024',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temukan hikmah di balik aset digital bersama Averroes Academy.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  _AksiBanner(
                    label: 'Baca',
                    icon: Symbols.chrome_reader_mode,
                    warna: Colors.white,
                    warnaText: const Color(0xFF065F46),
                  ),
                  const SizedBox(width: 10),
                  _AksiBanner(
                    label: '',
                    icon: Symbols.download,
                    warna: Colors.white24,
                    warnaText: Colors.white,
                    ukuran: 48,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AksiBanner extends StatelessWidget {
  const _AksiBanner({
    required this.label,
    required this.icon,
    required this.warna,
    required this.warnaText,
    this.ukuran,
  });

  final String label;
  final IconData icon;
  final Color warna;
  final Color warnaText;
  final double? ukuran;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 0 : 18, vertical: 12),
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: warna.withOpacity(0.4)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 18, color: warnaText),
          if (label.isNotEmpty) ...<Widget>[
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: warnaText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _JudulBagian extends StatelessWidget {
  const _JudulBagian({required this.judul, required this.aksi});

  final String judul;
  final String aksi;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          judul,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1F2937),
          ),
        ),
        Text(
          aksi,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF059669),
          ),
        ),
      ],
    );
  }
}

class _KartuDokumen extends StatelessWidget {
  const _KartuDokumen({
    required this.judul,
    required this.tag,
    required this.info,
    required this.icon,
    required this.warnaIcon,
    required this.warnaTag,
    this.nonAktif = false,
  });

  final String judul;
  final String tag;
  final String info;
  final IconData icon;
  final Color warnaIcon;
  final Color warnaTag;
  final bool nonAktif;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: nonAktif ? 0.6 : 1,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: warnaIcon,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 36, color: warnaTag),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    judul,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: warnaTag.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: warnaTag,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        info,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (nonAktif)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'BELUM TERSEDIA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'BACA',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF065F46),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: const Icon(
                            Symbols.download_rounded,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuPermintaan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFDE68A).withOpacity(0.6)),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -6,
            bottom: -6,
            child: Icon(
              Symbols.contact_support,
              size: 80,
              color: const Color(0xFFFBBF24).withOpacity(0.2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Request Dokumen?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF92400E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Belum menemukan fatwa yang Anda cari? Beritahu kami dan tim ahli akan segera mencarikannya untuk Anda.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB45309),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Hubungi Support',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Symbols.arrow_forward,
                      size: 16,
                      color: Color(0xFFB45309),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipKategori {
  const _ChipKategori({
    required this.label,
    required this.icon,
    this.warnaIcon,
    this.aktif = false,
  });

  final String label;
  final IconData icon;
  final Color? warnaIcon;
  final bool aktif;
}
