cat > lib/services/queue_service.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';

class QueueService {
  static final QueueService _instance = QueueService._internal();
  factory QueueService() => _instance;

  QueueService._internal();

  List<String> _queue = [];
  int _currentIndex = 0;
  List<String> _history = [];

  List<String> get queue => _queue;
  int get currentIndex => _currentIndex;
  String? get currentSong => _queue.isNotEmpty ? _queue[_currentIndex] : null;
  List<String> get history => _history;

  void setQueue(List<String> newQueue, {int startAt = 0}) {
    _queue = newQueue;
    _currentIndex = startAt;
    _addToHistory(_queue[_currentIndex]);
  }

  void skipNext() {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      _addToHistory(_queue[_currentIndex]);
    }
  }

  void skipPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _addToHistory(_queue[_currentIndex]);
    }
  }

  void _addToHistory(String song) {
    _history.add(song);
    if (_history.length > 50) {
      _history.removeAt(0); // Limit history
    }
    _saveHistory();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('songHistory', _history);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('songHistory') ?? [];
  }
}
EOF
