import 'dart:async';
import 'package:flutter/material.dart';
import '../models/music_models.dart';
import '../services/musicbrainz_api.dart';
import '../widgets/state_views.dart';
import 'discography_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _query = TextEditingController();
  final _api = MusicBrainzApi();
  Future<List<Artist>>? _results;
  Timer? _searchDelay;

  void _search() {
    final text = _query.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _results = _api.searchArtists(text);
      });
    }
  }

  void _searchWhenTyping(String value) {
    _searchDelay?.cancel();
    if (value.trim().length < 2) return;
    _searchDelay = Timer(const Duration(milliseconds: 700), _search);
  }

  @override
  void dispose() {
    _searchDelay?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bandography', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text('Temukan diskografi band favoritmu.', style: TextStyle(color: Colors.deepPurple.shade100)),
            const SizedBox(height: 24),
            TextField(
              controller: _query,
              textInputAction: TextInputAction.search,
              onChanged: _searchWhenTyping,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Cari band atau musisi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(onPressed: _search, icon: const Icon(Icons.arrow_forward)),
                filled: true,
                fillColor: const Color(0xff25212f),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _results == null
                  ? const _Welcome()
                  : FutureBuilder<List<Artist>>(
                      future: _results,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
                        if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: _search);
                        final artists = snapshot.data!;
                        if (artists.isEmpty) return const Center(child: Text('Band tidak ditemukan.'));
                        return ListView.separated(
                          itemCount: artists.length,
                          separatorBuilder: (_, _) => const Divider(),
                          itemBuilder: (context, index) {
                            final artist = artists[index];
                            final subtitle = [artist.type, artist.country, artist.disambiguation].whereType<String>().where((value) => value.isNotEmpty).join(' • ');
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 6),
                              leading: CircleAvatar(child: Text(artist.name.substring(0, 1).toUpperCase())),
                              title: Text(artist.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(subtitle),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiscographyPage(artist: artist))),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Welcome extends StatelessWidget {
  const _Welcome();
  @override
  Widget build(BuildContext context) => const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.album_rounded, size: 76, color: Color(0xff9b8cff)), SizedBox(height: 16), Text('Cari band untuk melihat\ndiskografi dan track list.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17))]));
}
