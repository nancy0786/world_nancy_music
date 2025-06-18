import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeAutocompleteService {
  static Future<List<String>> fetchSuggestions(String query) async {
    try {
      final url = Uri.parse(
        'https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=$query',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final suggestions = List<String>.from(body[1]);
        return suggestions;
      } else {
        return [];
      }
    } catch (e) {
      print("🔴 Error fetching suggestions: $e");
      return [];
    }
  }
}
