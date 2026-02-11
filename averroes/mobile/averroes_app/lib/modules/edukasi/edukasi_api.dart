import 'package:dio/dio.dart';

import '../../app/config/app_config.dart';

class EdukasiApi {
  EdukasiApi({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<KelasEdukasi>> fetchKelas() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '${AppConfig.apiBaseUrl}/api/kelas',
    );

    final List<dynamic> rows = _extractList(response.data);
    return rows
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> row) => KelasEdukasi.fromJson(
              Map<String, dynamic>.from(row),
            ))
        .toList();
  }

  Future<List<MateriEdukasi>> fetchMateri(int kelasId) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '${AppConfig.apiBaseUrl}/api/materi',
      queryParameters: <String, dynamic>{'kelas_id': kelasId},
    );

    final List<dynamic> rows = _extractList(response.data);
    return rows
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> row) => MateriEdukasi.fromJson(
              Map<String, dynamic>.from(row),
            ))
        .toList();
  }

  Future<List<KuisEdukasi>> fetchKuis(int kelasId) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '${AppConfig.apiBaseUrl}/api/kuis',
      queryParameters: <String, dynamic>{'kelas_id': kelasId},
    );

    final List<dynamic> rows = _extractList(response.data);
    return rows
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> row) => KuisEdukasi.fromJson(
              Map<String, dynamic>.from(row),
            ))
        .toList();
  }

  List<dynamic> _extractList(dynamic rawResponse) {
    if (rawResponse is Map<String, dynamic>) {
      final dynamic data = rawResponse['data'];
      if (data is List<dynamic>) {
        return data;
      }
    }
    return <dynamic>[];
  }
}

class KelasEdukasi {
  KelasEdukasi({
    required this.id,
    required this.judul,
    required this.deskripsi,
  });

  final int id;
  final String judul;
  final String deskripsi;

  factory KelasEdukasi.fromJson(Map<String, dynamic> json) {
    return KelasEdukasi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      judul: (json['judul'] as String?)?.trim() ?? '-',
      deskripsi: (json['deskripsi'] as String?)?.trim() ?? '-',
    );
  }
}

class MateriEdukasi {
  MateriEdukasi({
    required this.id,
    required this.kelasId,
    required this.judul,
    required this.konten,
    required this.urutan,
  });

  final int id;
  final int kelasId;
  final String judul;
  final String konten;
  final int urutan;

  factory MateriEdukasi.fromJson(Map<String, dynamic> json) {
    return MateriEdukasi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      kelasId: (json['kelas_id'] as num?)?.toInt() ?? 0,
      judul: (json['judul'] as String?)?.trim() ?? '-',
      konten: (json['konten'] as String?)?.trim() ?? '-',
      urutan: (json['urutan'] as num?)?.toInt() ?? 0,
    );
  }
}

class KuisEdukasi {
  KuisEdukasi({
    required this.id,
    required this.kelasId,
    required this.pertanyaan,
  });

  final int id;
  final int kelasId;
  final String pertanyaan;

  factory KuisEdukasi.fromJson(Map<String, dynamic> json) {
    return KuisEdukasi(
      id: (json['id'] as num?)?.toInt() ?? 0,
      kelasId: (json['kelas_id'] as num?)?.toInt() ?? 0,
      pertanyaan: (json['pertanyaan'] as String?)?.trim() ?? '-',
    );
  }
}
