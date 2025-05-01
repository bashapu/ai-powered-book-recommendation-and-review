import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeQueryComponent(query)}');
    final response = await http.get(url);

    if (response.statusCode != 200) return [];

    final data = json.decode(response.body);
    final List items = data['items'] ?? [];

    return items.map((item) {
      final volume = item['volumeInfo'];
      return {
        'id': item['id'],
        'title': volume['title'] ?? 'Untitled',
        'authors': (volume['authors'] ?? []).join(', '),
        'description': volume['description'],
        'thumbnail': volume['imageLinks']?['thumbnail'],
      };
    }).toList();
  }
}
