import 'package:book_app/models/book_model.dart';
import 'package:book_app/screens/review_details_screen.dart';
import 'package:book_app/screens/write_review_screen.dart';
import 'package:book_app/services/library_service.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (book['thumbnail'] != null)
              Image.network(book['thumbnail'], height: 200),
            const SizedBox(height: 16),
            Text(book['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Author(s): ${book['authors']}'),
            const SizedBox(height: 16),
            Text(book['description'] ?? 'No description available.'),
            const SizedBox(height: 20),
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
