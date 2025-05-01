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
                // TODO: Add to My Library
              },
              child: const Text('Add to My Library'),
            ),
          ],
        ),
      ),
    );
  }
}
