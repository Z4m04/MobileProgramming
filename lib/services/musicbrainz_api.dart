import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/music_models.dart';

class MusicBrainzApi {
  static const _base = 'https://musicbrainz.org/ws/2';
  static DateTime? _lastRequest;
  Future<Map<String, dynamic>> _get(String path, [Map<String, String>? query, int attempt = 0]) async {
    final last = _lastRequest;
    if (last != null) { final wait = const Duration(seconds: 1) - DateTime.now().difference(last); if (!wait.isNegative) await Future.delayed(wait); }
    final uri = Uri.parse('$_base/$path').replace(queryParameters: {...?query, 'fmt': 'json'});
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, 'Bandography/1.0 (Flutter UTS project)');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      _lastRequest = DateTime.now();
      final response = await request.close();
      if (response.statusCode == HttpStatus.serviceUnavailable && attempt < 2) {
        await Future.delayed(Duration(seconds: attempt + 2));
        return await _get(path, query, attempt + 1);
      }
      if (response.statusCode != HttpStatus.ok) throw HttpException('Server mengembalikan status ${response.statusCode}.');
      return jsonDecode(await response.transform(utf8.decoder).join()) as Map<String, dynamic>;
    } on SocketException { throw const HttpException('Tidak dapat terhubung ke MusicBrainz. Periksa koneksi internet.');
    } finally { client.close(force: true); }
  }
  Future<List<Artist>> searchArtists(String query) async { final json = await _get('artist', {'query': query, 'limit': '20'}); return ((json['artists'] as List<dynamic>?) ?? []).map((e) => Artist.fromJson(e as Map<String, dynamic>)).toList(); }
  Future<List<ReleaseGroup>> discography(String artistId) async { final json = await _get('release-group', {'artist': artistId, 'limit': '100', 'type': 'album|ep|single'}); final list = ((json['release-groups'] as List<dynamic>?) ?? []).map((e) => ReleaseGroup.fromJson(e as Map<String, dynamic>)).toList(); list.sort((a,b) => (a.firstReleaseDate ?? '9999').compareTo(b.firstReleaseDate ?? '9999')); return list; }
  Future<AlbumDetail> albumDetail(ReleaseGroup album) async { final group = await _get('release-group/${album.id}', {'inc': 'releases'}); final releases = (group['releases'] as List<dynamic>?) ?? []; if (releases.isEmpty) return AlbumDetail(album: album, tracks: const []); final release = releases.first as Map<String, dynamic>; final json = await _get('release/${release['id']}', {'inc': 'recordings+labels'}); final tracks = ((json['media'] as List<dynamic>?) ?? []).expand((m) => ((m as Map<String,dynamic>)['tracks'] as List<dynamic>?) ?? []).map((t) => Track.fromJson(t as Map<String,dynamic>)).toList(); final labels=(json['label-info'] as List<dynamic>?) ?? []; final label=labels.isEmpty?null:(labels.first as Map<String,dynamic>)['label']?['name'] as String?; return AlbumDetail(album: album, tracks: tracks, releaseDate: json['date'] as String?, label: label); }
}
