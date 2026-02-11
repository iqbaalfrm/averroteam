import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HalamanPasar extends StatelessWidget {
  const HalamanPasar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white.withOpacity(0.8),
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Icon(
                          Symbols.arrow_back_ios,
                          size: 20,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Pasar Spot',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Symbols.search,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SentimenPasar(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Koin Populer',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        'Lihat Semua',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _KoinItem(
                    nama: 'Bitcoin',
                    ticker: 'BTC',
                    harga: 'Rp 1,02B',
                    perubahan: '+3.24%',
                    naik: true,
                    icon: Symbols.currency_bitcoin,
                    warna: const Color(0xFFFFEDD5),
                    warnaIcon: const Color(0xFFF97316),
                  ),
                  const SizedBox(height: 10),
                  _KoinItem(
                    nama: 'Ethereum',
                    ticker: 'ETH',
                    harga: 'Rp 56.4M',
                    perubahan: '-0.82%',
                    naik: false,
                    icon: Symbols.eco,
                    warna: const Color(0xFFE0E7FF),
                    warnaIcon: const Color(0xFF6366F1),
                  ),
                  const SizedBox(height: 10),
                  _KoinItem(
                    nama: 'Solana',
                    ticker: 'SOL',
                    harga: 'Rp 2.1M',
                    perubahan: '+5.41%',
                    naik: true,
                    icon: Symbols.token,
                    warna: const Color(0xFFF3E8FF),
                    warnaIcon: const Color(0xFFA855F7),
                  ),
                  const SizedBox(height: 10),
                  _KoinItem(
                    nama: 'Chainlink',
                    ticker: 'LINK',
                    harga: 'Rp 234rb',
                    perubahan: '-1.20%',
                    naik: false,
                    icon: Symbols.link,
                    warna: const Color(0xFFDBEAFE),
                    warnaIcon: const Color(0xFF60A5FA),
                  ),
                  const SizedBox(height: 24),
                  _AksiGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimenPasar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1FAE5).withOpacity(0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sentimen Global',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                  color: const Color(0xFF047857).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'BULLISH',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF064E3B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'Skor Pasar',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                  color: const Color(0xFF047857).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '72/100',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF064E3B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KoinItem extends StatelessWidget {
  const _KoinItem({
    required this.nama,
    required this.ticker,
    required this.harga,
    required this.perubahan,
    required this.naik,
    required this.icon,
    required this.warna,
    required this.warnaIcon,
  });

  final String nama;
  final String ticker;
  final String harga;
  final String perubahan;
  final bool naik;
  final IconData icon;
  final Color warna;
  final Color warnaIcon;

  @override
  Widget build(BuildContext context) {
    final Color warnaPerubahan = naik ? const Color(0xFF10B981) : const Color(0xFFF43F5E);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: warna,
                  shape: BoxShape.circle,
                  border: Border.all(color: warna.withOpacity(0.6)),
                ),
                child: Icon(icon, size: 22, color: warnaIcon),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nama,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    ticker,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    harga,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    perubahan,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: warnaPerubahan,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(
                Symbols.chevron_right,
                size: 18,
                color: Color(0xFFCBD5F5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AksiGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_AksiItem> items = <_AksiItem>[
      _AksiItem(label: 'Filter', icon: Symbols.search_insights),
      _AksiItem(label: 'Top Gain', icon: Symbols.trending_up),
      _AksiItem(label: 'Favorit', icon: Symbols.star),
      _AksiItem(label: 'Sektor', icon: Symbols.category),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map(
            (_AksiItem item) => Column(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    item.icon,
                    color: const Color(0xFF064E3B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _AksiItem {
  const _AksiItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
