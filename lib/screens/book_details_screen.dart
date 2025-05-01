import 'package:book_app/screens/review_details_screen.dart';
import 'package:book_app/screens/write_review_screen.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/library_service.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final String title = book['title'] ?? 'Unknown Title';
    final String authors = book['authors'] ?? 'Unknown Author';
    final String? thumbnail = book['thumbnail'];
    final String? description = book['description'];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thumbnail != null)
              Center(
                child: Image.network(thumbnail, height: 200),
              ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Author(s): $authors"),
            const SizedBox(height: 16),
            Text(description ?? 'No description available.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                LibraryService().addBook(
                  BookModel(
                    id: book['id'],
                    title: title,
                    authors: authors,
                    thumbnail: thumbnail,
                    description: description,
                    status: 'want_to_read',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book added to your library!')),
                );
              },
              child: const Text('Add to My Library'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WriteReviewScreen(bookId: book['id']),
                  ),
                );
              },
              child: const Text('Write a Review'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReviewDetailsScreen(bookId: book['id']),
                  ),
                );
              },
              child: const Text('See Reviews'),
            ),
          ],
        ),
      ),
    );
  }
}