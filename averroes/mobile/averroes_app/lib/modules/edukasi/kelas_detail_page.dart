import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'edukasi_api.dart';
import 'kuis_page.dart';

class HalamanDetailKelas extends StatefulWidget {
  const HalamanDetailKelas({required this.kelas, super.key});

  final KelasEdukasi kelas;

  @override
  State<HalamanDetailKelas> createState() => _HalamanDetailKelasState();
}

class _HalamanDetailKelasState extends State<HalamanDetailKelas> {
  final EdukasiApi _api = EdukasiApi();

  bool _isLoading = true;
  String? _error;
  List<MateriEdukasi> _materi = <MateriEdukasi>[];

  @override
  void initState() {
    super.initState();
    _loadMateri();
  }

  Future<void> _loadMateri() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final List<MateriEdukasi> items = await _api.fetchMateri(widget.kelas.id);
      setState(() {
        _materi = items;
      });
    } catch (_) {
      setState(() {
        _error = 'Gagal memuat materi kelas.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          'Detail Kelas',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMateri,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: <Widget>[
            _KelasHeader(kelas: widget.kelas),
            const SizedBox(height: 16),
            _sectionTitle('Daftar Materi'),
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              _ErrorCard(message: _error!, onRetry: _loadMateri)
            else if (_materi.isEmpty)
              const _EmptyCard(text: 'Belum ada materi di kelas ini.')
            else
              ..._materi.map((MateriEdukasi item) => _MateriCard(item: item)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HalamanKuis(kelas: widget.kelas),
                ),
              );
            },
            icon: const Icon(Symbols.quiz),
            label: Text(
              'Mulai Kuis',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: const Color(0xFF052E2B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0F172A),
      ),
    );
  }
}

class _KelasHeader extends StatelessWidget {
  const _KelasHeader({required this.kelas});

  final KelasEdukasi kelas;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            kelas.judul,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kelas.deskripsi,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MateriCard extends StatelessWidget {
  const _MateriCard({required this.item});

  final MateriEdukasi item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            'Materi ${item.urutan}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.judul,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.konten,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              height: 1.35,
            ),
          ),
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
