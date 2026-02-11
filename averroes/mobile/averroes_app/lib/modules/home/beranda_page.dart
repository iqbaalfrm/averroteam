import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:averroes_core/averroes_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/config/app_config.dart';
import '../../app/routes/app_routes.dart';
import '../../app/services/auth_service.dart';
import '../../app/widgets/guest_guard.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFFFFAF3),
              Color(0xFFF0FDFA),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderBerandaDelegate(
                topPadding: MediaQuery.of(context).padding.top,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _KartuJadwalShalat(),
                    const SizedBox(height: 20),
                    _KartuPortofolio(),
                    const SizedBox(height: 20),
                    _GridFitur(),
                    const SizedBox(height: 20),
                    _KartuLanjutkanBelajar(),
                    const SizedBox(height: 20),
                    _BagianBeritaTerbaru(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBerandaDelegate extends SliverPersistentHeaderDelegate {
  _HeaderBerandaDelegate({required this.topPadding});

  final double topPadding;

  @override
  double get minExtent => topPadding + 64;

  @override
  double get maxExtent => topPadding + 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFECFDF5).withOpacity(0.5),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFF059669),
                            Color(0xFF14B8A6),
                          ],
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Symbols.person,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Assalamu\u2019alaikum,',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: const Color(0xFF059669).withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            Text(
                              AuthService.instance.namaUser,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            if (AuthService.instance.adalahTamu) ...<Widget>[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: const Color(0xFFFDE68A)),
                                ),
                                child: Text(
                                  'Mode Tamu',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color: const Color(0xFFB45309),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.notifications_active,
                        color: Color(0xFF475569),
                        size: 22,
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _KartuJadwalShalat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -24,
            top: -24,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: 0.2,
                child: Icon(
                  Symbols.mosque,
                  size: 120,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Symbols.schedule,
                          size: 18,
                          color: Color(0xFF059669),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Jadwal Shalat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFDCFCE7)),
                    ),
                    child: Text(
                      'Sen, 24 Jun',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Jakarta',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Maghrib',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '18:05',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          Color(0xFFE2E8F0),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Makkah',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Dzuhur',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '12:22',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _GridFitur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isTamu = AuthService.instance.adalahTamu;

    final List<_ItemFitur> fitur = <_ItemFitur>[
      _ItemFitur(
        judul: 'Screener',
        ikon: Symbols.rule_folder,
        warna: const Color(0xFFE8F5F0),
        tujuan: RuteAplikasi.penyaring,
      ),
      _ItemFitur(
        judul: 'Pasar',
        ikon: Symbols.candlestick_chart,
        warna: const Color(0xFFEFF6FF),
        tujuan: RuteAplikasi.pasar,
      ),
      _ItemFitur(
        judul: 'Pustaka',
        ikon: Symbols.menu_book,
        warna: const Color(0xFFFFF7ED),
        tujuan: RuteAplikasi.pustaka,
      ),
      _ItemFitur(
        judul: 'Portofolio',
        ikon: Symbols.account_balance_wallet,
        warna: const Color(0xFFEDE9FE),
        tujuan: RuteAplikasi.portofolio,
        terbatasGuest: true,
      ),
      _ItemFitur(
        judul: 'Zakat',
        ikon: Symbols.calculate,
        warna: const Color(0xFFFFE4E6),
        tujuan: RuteAplikasi.zakat,
        terbatasGuest: true,
      ),
      _ItemFitur(
        judul: 'Psikolog',
        ikon: Symbols.psychology,
        warna: const Color(0xFFE0F2FE),
        tujuan: RuteAplikasi.psikolog,
        terbatasGuest: true,
      ),
      _ItemFitur(
        judul: 'Konsultasi',
        ikon: Symbols.support_agent,
        warna: const Color(0xFFFFEDD5),
        tujuan: RuteAplikasi.konsultasi,
        terbatasGuest: true,
      ),
      _ItemFitur(
        judul: 'Zikir',
        ikon: Symbols.auto_stories,
        warna: const Color(0xFFE2E8F0),
        tujuan: RuteAplikasi.zikir,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Fitur Utama',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: fitur.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (BuildContext context, int index) {
            final _ItemFitur item = fitur[index];
            final bool terkunci = isTamu && item.terbatasGuest;

            return InkWell(
              onTap: () {
                if (cekAksesGuest(context, item.tujuan)) {
                  return;
                }
                Get.toNamed(item.tujuan);
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: terkunci
                                ? const Color(0xFFF1F5F9)
                                : item.warna,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item.ikon,
                            size: 18,
                            color: terkunci
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.judul,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: terkunci
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (terkunci)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFFDE68A),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Symbols.lock,
                            size: 11,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _KartuLanjutkanBelajar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RuteAplikasi.edukasi),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFECFDF5),
              Color(0xFFFFFFFF),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Symbols.menu_book,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Lanjutkan Belajar',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kelas: Dasar Crypto Syariah (Materi 1/3)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Symbols.chevron_right,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemFitur {
  const _ItemFitur({
    required this.judul,
    required this.ikon,
    required this.warna,
    required this.tujuan,
    this.terbatasGuest = false,
  });

  final String judul;
  final IconData ikon;
  final Color warna;
  final String tujuan;
  final bool terbatasGuest;
}

class _BagianBeritaTerbaru extends StatefulWidget {
  @override
  State<_BagianBeritaTerbaru> createState() => _BagianBeritaTerbaruState();
}

class _BagianBeritaTerbaruState extends State<_BagianBeritaTerbaru> {
  List<Map<String, dynamic>> _beritaList = <Map<String, dynamic>>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBerita();
  }

  Future<void> _fetchBerita() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final Dio dio = Dio();
      final Response<dynamic> response = await dio.get<dynamic>(
        '${AppConfig.apiBaseUrl}/api/berita?limit=10',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        if (data['status'] == true && data['data'] != null) {
          final Map<String, dynamic> innerData =
              data['data'] as Map<String, dynamic>;
          final List<dynamic> beritaRaw =
              innerData['berita'] as List<dynamic>? ?? <dynamic>[];

          setState(() {
            _beritaList = beritaRaw
                .map((dynamic e) => e as Map<String, dynamic>)
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = data['pesan']?.toString() ?? 'Gagal memuat berita';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Tidak dapat terhubung ke server';
        _isLoading = false;
      });
    }
  }

  Future<void> _bukaBerita(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Symbols.newspaper,
                    size: 18,
                    color: Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Berita Aset Kripto',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            if (!_isLoading)
              GestureDetector(
                onTap: _fetchBerita,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFD1FAE5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Symbols.refresh,
                        size: 14,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Perbarui',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Sumber: cryptowave.co.id',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          _buildLoadingShimmer()
        else if (_errorMessage != null)
          _buildError()
        else if (_beritaList.isEmpty)
          _buildEmpty()
        else
          ..._beritaList.map(
            (Map<String, dynamic> item) => _buildKartuBerita(item),
          ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List<Widget>.generate(
        3,
        (int i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: <Widget>[
          const Icon(Symbols.cloud_off, size: 32, color: Color(0xFFEF4444)),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Terjadi kesalahan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFEF4444),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _fetchBerita,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Coba Lagi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Symbols.article,
            size: 32,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada berita terbaru',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKartuBerita(Map<String, dynamic> item) {
    final String judul = (item['judul'] as String?) ?? '';
    final String ringkasan = (item['ringkasan'] as String?) ?? '';
    final String penulis = (item['penulis'] as String?) ?? '';
    final String tanggal = (item['tanggal_asli'] as String?) ?? '';
    final String sumberUrl = (item['sumber_url'] as String?) ?? '';
    final String gambarUrl = (item['gambar_url'] as String?) ?? '';

    return GestureDetector(
      onTap: () => _bukaBerita(sumberUrl),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: gambarUrl.isNotEmpty
                  ? Image.network(
                      gambarUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Symbols.newspaper,
                            size: 28,
                            color: Color(0xFF059669),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Symbols.newspaper,
                        size: 28,
                        color: Color(0xFF059669),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    judul,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (ringkasan.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      ringkasan,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      if (penulis.isNotEmpty) ...[
                        Icon(
                          Symbols.person,
                          size: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            penulis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (penulis.isNotEmpty && tanggal.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCBD5E1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      if (tanggal.isNotEmpty)
                        Flexible(
                          child: Text(
                            tanggal,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Symbols.open_in_new,
              size: 16,
              color: Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }
}


class _KartuPortofolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.white,
            Color(0xFFF0FDF4),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -16,
            top: -16,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFDE68A).withOpacity(0.5)),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Symbols.account_balance_wallet,
                          color: Color(0xFFF59E0B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Total Portfolio',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp 0',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.8)),
                    ),
                    child: const Icon(
                      Symbols.visibility_off,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 1,
                color: const Color(0xFFDCFCE7).withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: const Color(0xFF64748B),
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: 'Status: '),
                        TextSpan(
                          text: 'Siap Berinvestasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x33059669),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Mulai Investasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Symbols.arrow_forward,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
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
