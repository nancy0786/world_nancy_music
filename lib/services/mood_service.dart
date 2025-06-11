class MoodService {
  static String getCurrentMood() {
    final hour = DateTime.now().hour;
    if (hour < 10) return 'Morning Vibes';
    if (hour < 16) return 'Chill Beats';
    if (hour < 20) return 'Evening Energy';
    return 'Night Relaxation';
  }

  static List<String> getSongsForMood(String mood) {
    switch (mood) {
      case 'Morning Vibes':
        return ['calm lo-fi', 'acoustic morning'];
      case 'Chill Beats':
        return ['lofi chillhop', 'study music'];
      case 'Evening Energy':
        return ['edm hits', 'bollywood dance'];
      case 'Night Relaxation':
        return ['sleep music', 'ambient rain'];
      default:
        return ['trending india'];
    }
  }
}
