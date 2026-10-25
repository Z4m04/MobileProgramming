class Artist {
  const Artist({required this.id, required this.name, this.country, this.type, this.disambiguation});
  final String id, name;
  final String? country, type, disambiguation;
  factory Artist.fromJson(Map<String, dynamic> json) => Artist(id: json['id'] as String, name: json['name'] as String, country: json['country'] as String?, type: json['type'] as String?, disambiguation: json['disambiguation'] as String?);
}

class ReleaseGroup {
  const ReleaseGroup({required this.id, required this.title, this.firstReleaseDate, this.primaryType});
  final String id, title;
  final String? firstReleaseDate, primaryType;
  factory ReleaseGroup.fromJson(Map<String, dynamic> json) => ReleaseGroup(id: json['id'] as String, title: json['title'] as String, firstReleaseDate: json['first-release-date'] as String?, primaryType: json['primary-type'] as String?);
}

class Track {
  const Track({required this.number, required this.title, this.lengthMs});
  final String number, title;
  final int? lengthMs;
  factory Track.fromJson(Map<String, dynamic> json) => Track(number: json['number']?.toString() ?? '-', title: json['title'] as String? ?? 'Tanpa judul', lengthMs: json['length'] as int?);
  String get duration { if (lengthMs == null) return ''; final seconds = lengthMs! ~/ 1000; return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}'; }
}

class AlbumDetail { const AlbumDetail({required this.album, required this.tracks, this.releaseDate, this.label}); final ReleaseGroup album; final List<Track> tracks; final String? releaseDate, label; }
