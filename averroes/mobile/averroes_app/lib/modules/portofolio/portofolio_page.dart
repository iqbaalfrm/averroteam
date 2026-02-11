import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HalamanPortofolio extends StatelessWidget {
  const HalamanPortofolio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFFCF9F6),
              Color(0xFFF5F7F9),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFFFCF9F6).withOpacity(0.85),
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
                        _IconCircleButton(
                          icon: Symbols.chevron_left,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Portofolio Saya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    _IconCircleButton(
                      icon: Symbols.insights,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _RingkasanSaldo(),
                    const SizedBox(height: 20),
                    _AksiCepat(),
                    const SizedBox(height: 20),
                    _KartuAlokasiAset(),
                    const SizedBox(height: 24),
                    _JudulBagian(
                      judul: 'Daftar Aset',
                      aksi: 'Filter',
                      ikon: Symbols.sort,
                    ),
                    const SizedBox(height: 16),
                    _KartuAset(
                      judul: 'Bitcoin (BTC)',
                      subjudul: 'Kripto Syariah',
                      nilai: 'Rp 56.025.000',
                      perubahan: '+4.2%',
                      naik: true,
                      icon: Symbols.currency_bitcoin,
                      warna: const Color(0xFFE0E7FF),
                      warnaIcon: const Color(0xFF6366F1),
                    ),
                    const SizedBox(height: 12),
                    _KartuAset(
                      judul: 'Bank Syariah Indo',
                      subjudul: 'Saham BEI',
                      nilai: 'Rp 37.350.000',
                      perubahan: '-1.2%',
                      naik: false,
                      icon: Symbols.account_balance,
                      warna: const Color(0xFFDCFCE7),
                      warnaIcon: const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 12),
                    _KartuAset(
                      judul: 'Ethereum (ETH)',
                      subjudul: 'Kripto Syariah',
                      nilai: 'Rp 18.675.000',
                      perubahan: '+0.8%',
                      naik: true,
                      icon: Symbols.token,
                      warna: const Color(0xFFFEF3C7),
                      warnaIcon: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 12),
                    _KartuAset(
                      judul: 'Kas Tunai',
                      subjudul: 'Likuiditas',
                      nilai: 'Rp 12.450.000',
                      perubahan: 'Stabil',
                      naik: null,
                      icon: Symbols.payments,
                      warna: const Color(0xFFFCE7F3),
                      warnaIcon: const Color(0xFFEC4899),
                    ),
                    const SizedBox(height: 40),
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
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF334155)),
      ),
    );
  }
}

class _RingkasanSaldo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Estimasi Total Saldo',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rp 124.500.000',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFD1FAE5).withOpacity(0.6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Symbols.trending_up,
                size: 18,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Text(
                '+Rp 2.450.000 (1.9%)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF047857),
                ),
              ),
              Container(
                width: 1,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: const Color(0xFFBBF7D0),
              ),
              Text(
                'Bulan Ini',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AksiCepat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _AksiButton(
            label: 'Tambah',
            icon: Symbols.add,
            warnaIcon: const Color(0xFF10B981),
            warnaLatar: const Color(0xFFECFDF5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AksiButton(
            label: 'Riwayat',
            icon: Symbols.history,
            warnaIcon: const Color(0xFF6366F1),
            warnaLatar: const Color(0xFFE0E7FF),
          ),
        ),
      ],
    );
  }
}

class _AksiButton extends StatelessWidget {
  const _AksiButton({
    required this.label,
    required this.icon,
    required this.warnaIcon,
    required this.warnaLatar,
  });

  final String label;
  final IconData icon;
  final Color warnaIcon;
  final Color warnaLatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: warnaLatar,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: warnaIcon),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuAlokasiAset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Alokasi Aset',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Distribusi portofolio aktif',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const Icon(
                Symbols.pie_chart,
                color: Color(0xFFCBD5F5),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              _DonatAset(),
              const SizedBox(width: 20),
              const Expanded(child: _DetailAset()),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonatAset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: <Color>[
            Color(0xFF4F46E5),
            Color(0xFF4F46E5),
            Color(0xFF10B981),
            Color(0xFF10B981),
            Color(0xFFF59E0B),
            Color(0xFFF59E0B),
            Color(0xFFEC4899),
            Color(0xFFEC4899),
          ],
          stops: <double>[0, 0.45, 0.45, 0.75, 0.75, 0.9, 0.9, 1],
        ),
      ),
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '4',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                'ASET',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailAset extends StatelessWidget {
  const _DetailAset();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        _BarDistribusi(
          label: 'Kripto',
          persen: '45%',
          warna: Color(0xFF4F46E5),
          lebar: 0.45,
        ),
        SizedBox(height: 10),
        _BarDistribusi(
          label: 'Saham',
          persen: '30%',
          warna: Color(0xFF10B981),
          lebar: 0.30,
        ),
        SizedBox(height: 10),
        _BarDistribusi(
          label: 'Sukuk',
          persen: '15%',
          warna: Color(0xFFF59E0B),
          lebar: 0.15,
        ),
      ],
    );
  }
}

class _BarDistribusi extends StatelessWidget {
  const _BarDistribusi({
    required this.label,
    required this.persen,
    required this.warna,
    required this.lebar,
  });

  final String label;
  final String persen;
  final Color warna;
  final double lebar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: warna,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            Text(
              persen,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            widthFactor: lebar,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: warna,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _JudulBagian extends StatelessWidget {
  const _JudulBagian({required this.judul, required this.aksi, required this.ikon});

  final String judul;
  final String aksi;
  final IconData ikon;

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
            color: const Color(0xFF1E293B),
          ),
        ),
        Row(
          children: <Widget>[
            Icon(ikon, size: 18, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Text(
              aksi,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KartuAset extends StatelessWidget {
  const _KartuAset({
    required this.judul,
    required this.subjudul,
    required this.nilai,
    required this.perubahan,
    required this.icon,
    required this.warna,
    required this.warnaIcon,
    this.naik,
  });

  final String judul;
  final String subjudul;
  final String nilai;
  final String perubahan;
  final IconData icon;
  final Color warna;
  final Color warnaIcon;
  final bool? naik;

  @override
  Widget build(BuildContext context) {
    final Color warnaPerubahan = naik == null
        ? const Color(0xFF94A3B8)
        : (naik! ? const Color(0xFF10B981) : const Color(0xFFF43F5E));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF8FAFC)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: warna.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 26, color: warnaIcon),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    judul,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subjudul.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: const Color(0xFF94A3B8),
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
                nilai,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Text(
                    perubahan,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: warnaPerubahan,
                    ),
                  ),
                  if (naik != null) ...<Widget>[
                    const SizedBox(width: 4),
                    Icon(
                      naik! ? Symbols.trending_up : Symbols.trending_down,
                      size: 14,
                      color: warnaPerubahan,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
