import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeAutocompleteService {
  static Future<List<String>> fetchSuggestions(String query) async {
    try {
      final encoded = Uri.encodeComponent(query);
      final url = Uri.parse(
        'https://clients1.google.com/complete/search?client=youtube&hl=en&gl=US&ds=yt&q=$encoded'
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final raw = response.body;

        // Extract JSON string from raw response
        final start = raw.indexOf('[');
        final end = raw.lastIndexOf(']') + 1;
        final jsonStr = raw.substring(start, end);
        final List data = json.decode(jsonStr);

        return List<String>.from(data[1].map((item) => item[0]));
      } else {
        return [];
      }
    } catch (e) {
      print("🔴 Error fetching suggestions: $e");
      return [];
    }
  }
}
