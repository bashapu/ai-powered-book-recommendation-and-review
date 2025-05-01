import 'package:flutter/material.dart';
import '../services/google_books_service.dart';
import 'book_details_screen.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  void _searchBooks(String query) async {
    setState(() => _isLoading = true);
    final results = await GoogleBooksService.searchBooks(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return ListTile(
      leading:
          book['thumbnail'] != null
              ? Image.network(book['thumbnail'], width: 50, fit: BoxFit.cover)
              : const Icon(Icons.book),
      title: Text(book['title']),
      subtitle: Text(book['authors']),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BookDetailsScreen(
                  book: {
                    'id': book['id'],
                    'title': book['title'],
                    'authors': book['authors'],
                    'description': book['description'] ?? '',
                    'thumbnail': book['thumbnail'],
                  },
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onSubmitted: _searchBooks,
              decoration: InputDecoration(
                hintText: 'Search for books...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchBooks(_controller.text),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (_, i) => _buildBookCard(_results[i]),
                  ),
                ),
        ],
      ),
    );
  }
}
