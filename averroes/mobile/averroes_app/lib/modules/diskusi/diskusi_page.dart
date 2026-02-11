import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HalamanDiskusi extends StatelessWidget {
  const HalamanDiskusi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFF6F8F8).withOpacity(0.85),
                elevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                toolbarHeight: 78,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _IconCircleButton(
                                icon: Symbols.arrow_back,
                                onTap: () => Navigator.of(context).maybePop(),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Diskusi Crypto',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D3D33),
                                ),
                              ),
                            ],
                          ),
                          const _IconCircleButton(icon: Symbols.notifications),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(100),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      children: <Widget>[
                        _SearchBox(
                          hint: 'Cari topik diskusi crypto syariah...',
                        ),
                        const SizedBox(height: 10),
                        _KategoriDiskusi(),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _SwitchFilter(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  child: Column(
                    children: const <Widget>[
                      _KartuDiskusi(
                        nama: 'Ahmad Fauzi',
                        waktu: '2 jam yang lalu',
                        kategori: 'Token Syariah',
                        judul: 'Analisis Halal Koin Lapis 1 (Layer 1)',
                        ringkas:
                            'Mari bedah fundamental dan aspek syariah dari beberapa koin Layer 1 populer. Apakah mekanisme konsensusnya sudah memenuhi kaidah muamalah?',
                        gambar:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBrR40Uis2oGOP92WN-mWicwd-gJChIZPFkPxDo9UdJnBG1cul47PdvOGzf131gkQvX4e0fWh4ufZr7EkPP62w0qQnrpoRG7XGH-jBLrU6ZP_1ySlv5OI_6nDzGveZ8y0NnVDHYjlm2GPCOLQoADdlwDu7PS4h59exK0gQ1lZz-GQwz7_rjLbJkZb3PW2DkVZq7vqQqu01XW_SMpSMRnOex_ZU29-x0ux2QQ-V79V9jlo9OL6Qarxj0uc8MpAWVLfkJk_b89s8eGuI',
                        avatar:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB6PHWoUTqYK5HjhZRF9FJDIwGomK14W5XRv9kHGGBaOXOW65ULFkHiqha5gWICUvnuZV4tFYEK4G-zdRiK77Ag2xzN-SMePTg-tLVoE8NC0E8TW_i1xQDfCCcAuuy_eqFJ_SL22nCQc4syriwoa_aDKXN_VegGd3sVZr-gDhZBgHZ5hyJfBBpRKIGAh8EVsqfyF7yXUxzXb2VDjSMbHV3IamosHReuACnBTXxccwT412w3uyuiTuOi-EwW-LclZFd1IZq-ywFlWZ8',
                        suka: '124',
                        komentar: '45',
                      ),
                      SizedBox(height: 14),
                      _KartuDiskusi(
                        nama: 'Siti Aminah',
                        waktu: '5 jam yang lalu',
                        kategori: 'Blockchain',
                        judul: 'Cara Cek Kontrak Cerdas Syariah',
                        ringkas:
                            'Tips untuk pemula dalam membaca Smart Contract di explorer untuk memastikan tidak ada unsur gharar atau riba yang tersembunyi dalam kode.',
                        avatar:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCCmlpylGKgIO98QdVkpaOd84q2UNXgNYx8J4pXDBE7mjPqEbbubRKszAZpIoVkyHEUHosx233DAbc1wy2OIUPQ_RQRWwbgZDZOrQcRETg0W-u50ZfwQy3RRYN22Oxujxk0dZnPFP2iXCKiricSLdGPUzFThlxCcL_E5MrzA1LaoNoII0ekwbuh4MJZ6rWOWawFCT7-e6oA3Mwt0YZhp67Mgyyn3DZ1HCU2l2NUpYdwmC0dF-aeak89rW9nlfdHV0cKPhm5YxxJ8oM',
                        suka: '89',
                        komentar: '12',
                      ),
                      SizedBox(height: 14),
                      _KartuDiskusi(
                        nama: 'Budi Santoso',
                        waktu: '1 hari yang lalu',
                        kategori: 'Airdrop Syariah',
                        judul: 'Berburu Airdrop Tanpa Unsur Spekulasi',
                        ringkas:
                            'Banyak airdrop baru bermunculan, bagaimana memilah mana yang merupakan hibah (pemberian) yang sah dan mana yang berpotensi maysir?',
                        avatar:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD63DxvBIMf4hAaphhWb1PAfoWx1zA1NDkm_iO70YoHoJqGKXtr8NeDaJ5x7ijriQ-D_7E-_leK7BYvxsTyuuMy8kFWwpmhdEilSwFMdjV6r7b5bKOiBFyMwHMwjgGbuGuTolDOsFlsCFsyzBY-2BgqQBgMJYvSAGQchfSIuhJn1bbSitIAqPzHRENLl6bZisX7lg1151UeHhxzhdY9MlQlB8styBOkFUJcnQHHskBNsAe1ljPCFUq3WrC3eyow8xM48vKaYfEyHHE',
                        suka: '210',
                        komentar: '108',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 96,
            child: GestureDetector(
              onTap: () => _showBuatDiskusi(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF13ECB9),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x4D13ECB9),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Symbols.add_comment,
                      size: 20,
                      color: Color(0xFF0D3D33),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Buat Diskusi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D3D33),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showBuatDiskusi(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return const _SheetBuatDiskusi();
    },
  );
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
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF0D3D33)),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 14),
          const Icon(
            Symbols.search,
            size: 20,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hint,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KategoriDiskusi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> labels = <String>[
      'Semua',
      'Token Syariah',
      'Trading Spot',
      'Airdrop Syariah',
      'Blockchain',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels
            .asMap()
            .entries
            .map(
              (MapEntry<int, String> item) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: item.key == 0 ? const Color(0xFF13ECB9).withOpacity(0.2) : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: item.key == 0 ? const Color(0xFF13ECB9).withOpacity(0.3) : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Text(
                    item.value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.key == 0 ? const Color(0xFF0D3D33) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SwitchFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Terpopuler',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D3D33),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Terbaru',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuDiskusi extends StatelessWidget {
  const _KartuDiskusi({
    required this.nama,
    required this.waktu,
    required this.kategori,
    required this.judul,
    required this.ringkas,
    required this.avatar,
    required this.suka,
    required this.komentar,
    this.gambar,
  });

  final String nama;
  final String waktu;
  final String kategori;
  final String judul;
  final String ringkas;
  final String avatar;
  final String suka;
  final String komentar;
  final String? gambar;

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
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nama,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D3D33),
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '$waktu • '),
                        TextSpan(
                          text: kategori,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF13ECB9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            judul,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D3D33),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ringkas,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          if (gambar != null) ...<Widget>[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                gambar!,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: const Color(0xFFF1F5F9).withOpacity(0.8)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _AksiDiskusi(icon: Symbols.thumb_up, label: suka),
                    const SizedBox(width: 16),
                    _AksiDiskusi(icon: Symbols.chat_bubble, label: komentar),
                  ],
                ),
                _AksiDiskusi(icon: Symbols.share, label: 'Bagikan'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AksiDiskusi extends StatelessWidget {
  const _AksiDiskusi({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _SheetBuatDiskusi extends StatelessWidget {
  const _SheetBuatDiskusi();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Buat Diskusi Baru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D3D33),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Symbols.close,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    _FieldLabel(label: 'Judul Diskusi'),
                    const SizedBox(height: 6),
                    _InputField(
                      hint: 'Contoh: Status halal koin Layer 1',
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Kategori'),
                    const SizedBox(height: 6),
                    _SelectField(
                      value: 'Token Syariah',
                      hint: 'Pilih kategori',
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Ringkasan'),
                    const SizedBox(height: 6),
                    _InputField(
                      hint: 'Tuliskan ringkasan singkat agar mudah dipahami.',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Lampiran (opsional)'),
                    const SizedBox(height: 6),
                    _AttachmentCard(),
                    const SizedBox(height: 20),
                    _DisclaimerCard(),
                    const SizedBox(height: 20),
                    _PrimaryButton(label: 'Publikasikan'),
                    const SizedBox(height: 10),
                    _SecondaryButton(label: 'Simpan Draft'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0D3D33),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.hint, required this.maxLines});

  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        hint,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
        maxLines: maxLines,
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({required this.value, required this.hint});

  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            value.isEmpty ? hint : value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: value.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0D3D33),
            ),
          ),
          const Icon(
            Symbols.expand_more,
            color: Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Symbols.attach_file,
              size: 20,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tambahkan gambar atau dokumen pendukung.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Pilih',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D3D33),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Symbols.info,
            size: 18,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pastikan diskusi beradab, tidak mengandung ajakan spekulasi, dan tidak memberikan fatwa.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF13ECB9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D3D33),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D3D33),
          ),
        ),
      ),
    );
  }
}
