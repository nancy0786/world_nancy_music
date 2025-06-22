import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_music_nancy/components/base_screen.dart';
import 'package:world_music_nancy/screens/player_screen.dart';
import 'package:world_music_nancy/services/ytdlp_service.dart';
import 'package:world_music_nancy/services/youtube_autocomplete_service.dart';
import 'package:world_music_nancy/widgets/neon_aware_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _results = [];
  List<String> _history = [];
  List<String> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _controller.addListener(_onTyping);
  }

  void _onTyping() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final onlineSuggestions =
        await YouTubeAutocompleteService.fetchSuggestions(text);
    setState(() {
      _suggestions = onlineSuggestions.take(8).toList();
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('search_history') ?? [];
    setState(() => _history = stored);
  }

  Future<void> _saveSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _history.remove(query);
    _history.insert(0, query);
    await prefs.setStringList('search_history', _history.take(20).toList());
    _loadSearchHistory();
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() => _history = []);
  }

  Future<void> _deleteHistoryItem(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _history.remove(query);
    await prefs.setStringList('search_history', _history);
    _loadSearchHistory();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _suggestions = [];
      _results = [];
    });

    await _saveSearchHistory(query);

    try {
      final results = await YtDlpService.search(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _play(String videoId, String title, String url) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          title: title,
          author: 'YouTube',
          url: url,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search YouTube...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => _search(_controller.text),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: _search,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Nancy Music World",
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 22,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 8)],
              ),
            ),
            if (_suggestions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(_suggestions.length),
                    children: _suggestions
                        .map((s) => NeonAwareTile(
                              title: Text(s,
                                  style:
                                      const TextStyle(color: Colors.white)),
                              leading: const Icon(Icons.search,
                                  color: Colors.cyanAccent),
                              onTap: () {
                                _controller.text = s;
                                _search(s);
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            if (_results.isEmpty &&
                !_isLoading &&
                _controller.text.isEmpty)
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Search History",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                          TextButton(
                            onPressed: _clearHistory,
                            child: const Text("Clear",
                                style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _history.length,
                        itemBuilder: (_, index) {
                          final item = _history[index];
                          return NeonAwareTile(
                            title: Text(item,
                                style:
                                    const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.history,
                                color: Colors.cyan),
                            trailing: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.redAccent),
                              onPressed: () => _deleteHistoryItem(item),
                            ),
                            onTap: () {
                              _controller.text = item;
                              _search(item);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child:
                    CircularProgressIndicator(color: Colors.cyanAccent),
              ),
            if (!_isLoading && _results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final video = _results[index];
                    return NeonAwareTile(
                      leading: Image.network(
                        video['thumbnail'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(video['title'] ?? '',
                          style:
                              const TextStyle(color: Colors.white)),
                      subtitle: Text(video['channel'] ?? '',
                          style:
                              const TextStyle(color: Colors.white70)),
                      onTap: () => _play(video['videoId']!,
                          video['title']!, video['url']!),
                    );
                  },
                ),
              ),
            if (!_isLoading &&
                _results.isEmpty &&
                _controller.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("🚫 No results found",
                    style: TextStyle(color: Colors.white70)),
              ),
            Container(
              height: 60,
              alignment: Alignment.center,
              color: Colors.black87,
              child: const Text(
                "🎵 Mini Player - Tap to open",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
