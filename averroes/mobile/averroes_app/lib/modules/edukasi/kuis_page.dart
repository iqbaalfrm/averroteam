import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edukasi_api.dart';

class HalamanKuis extends StatefulWidget {
  const HalamanKuis({required this.kelas, super.key});

  final KelasEdukasi kelas;

  @override
  State<HalamanKuis> createState() => _HalamanKuisState();
}

class _HalamanKuisState extends State<HalamanKuis> {
  final EdukasiApi _api = EdukasiApi();

  bool _isLoading = true;
  String? _error;
  List<KuisEdukasi> _kuis = <KuisEdukasi>[];
  final Map<int, int> _selectedOptionByKuisId = <int, int>{};

  @override
  void initState() {
    super.initState();
    _loadKuis();
  }

  Future<void> _loadKuis() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final List<KuisEdukasi> items = await _api.fetchKuis(widget.kelas.id);
      setState(() {
        _kuis = items;
      });
    } catch (_) {
      setState(() {
        _error = 'Gagal memuat kuis kelas ini.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitDummy() {
    final int total = _kuis.length;
    final int answered = _selectedOptionByKuisId.length;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selesai (Mode Dummy)'),
          content: Text('Jawaban terisi $answered dari $total soal.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Text(
          'Kuis: ${widget.kelas.judul}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadKuis,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1FAE5)),
              ),
              child: Text(
                'Opsi jawaban di halaman ini adalah dummy untuk kebutuhan UI testing.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF065F46),
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              _ErrorCard(message: _error!, onRetry: _loadKuis)
            else if (_kuis.isEmpty)
              const _EmptyCard(text: 'Belum ada soal kuis di kelas ini.')
            else
              ..._kuis.asMap().entries.map((MapEntry<int, KuisEdukasi> entry) {
                final int idx = entry.key;
                final KuisEdukasi soal = entry.value;
                final List<String> options =
                    _buildDummyOptions(soal.pertanyaan);

                return _QuestionCard(
                  nomor: idx + 1,
                  soal: soal,
                  options: options,
                  selected: _selectedOptionByKuisId[soal.id],
                  onSelect: (int value) {
                    setState(() {
                      _selectedOptionByKuisId[soal.id] = value;
                    });
                  },
                );
              }),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitDummy,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF052E2B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Kumpulkan Jawaban',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _buildDummyOptions(String pertanyaan) {
    final String lower = pertanyaan.toLowerCase();

    if (lower.contains('blockchain')) {
      return <String>[
        'Mencatat transaksi secara terdesentralisasi',
        'Menghapus risiko pasar sepenuhnya',
        'Menggantikan semua sistem bank',
        'Membuat harga aset selalu naik',
      ];
    }

    if (lower.contains('zakat')) {
      return <String>[
        'Dipertimbangkan saat mencapai nisab dan haul',
        'Selalu wajib setiap minggu',
        'Hanya berlaku untuk stablecoin',
        'Tidak pernah ada dalam aset digital',
      ];
    }

    if (lower.contains('risiko') || lower.contains('stop loss')) {
      return <String>[
        'Membatasi kerugian sesuai rencana',
        'Menjamin profit',
        'Menambah leverage otomatis',
        'Menghilangkan volatilitas pasar',
      ];
    }

    return <String>[
      'Pilihan A (dummy)',
      'Pilihan B (dummy)',
      'Pilihan C (dummy)',
      'Pilihan D (dummy)',
    ];
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.nomor,
    required this.soal,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final int nomor;
  final KuisEdukasi soal;
  final List<String> options;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Soal $nomor',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            soal.pertanyaan,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          ...options.asMap().entries.map((MapEntry<int, String> entry) {
            return RadioListTile<int>(
              value: entry.key,
              groupValue: selected,
              onChanged: (int? value) {
                if (value != null) {
                  onSelect(value);
                }
              },
              title: Text(
                entry.value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF334155),
                ),
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            );
          }),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            message,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB91C1C),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }
}
