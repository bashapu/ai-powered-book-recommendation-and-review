import 'package:book_app/screens/review_details_screen.dart';
import 'package:book_app/screens/write_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../services/library_service.dart';

class BookDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool _alreadyAdded = false;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _checkIfBookAlreadyInLibrary();
  }

  Future<void> _checkIfBookAlreadyInLibrary() async {
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('library')
        .doc(widget.book['id'])
        .get();

    setState(() {
      _alreadyAdded = doc.exists;
    });
  }

  void _addToLibrary() async {
    final bookModel = BookModel(
      id: widget.book['id'],
      title: widget.book['title'],
      authors: widget.book['authors'],
      thumbnail: widget.book['thumbnail'],
      description: widget.book['description'],
      status: 'want_to_read',
    );

    await LibraryService().addBook(bookModel);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added to your library!')),
      );
      setState(() {
        _alreadyAdded = true;
      });
    }
  }

  void _confirmRemoveFromLibrary() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Book'),
            content: const Text(
              'Are you sure you want to remove this book from your library?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('library')
          .doc(widget.book['id'])
          .delete();

      if (mounted) {
        setState(() {
          _alreadyAdded = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book removed from your library.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.book['title'] ?? 'Unknown Title';
    final authors = widget.book['authors'] ?? 'Unknown Author';
    final thumbnail = widget.book['thumbnail'];
    final description = widget.book['description'] ?? 'No description available.';

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
            Text(description),
            const SizedBox(height: 24),

            _alreadyAdded
                ? ElevatedButton.icon(
                  onPressed: _confirmRemoveFromLibrary,
                  icon: const Icon(Icons.check),
                  label: const Text('Already in My Library (Tap to Remove)'),
                )
                : ElevatedButton.icon(
                  onPressed: _addToLibrary,
                  icon: const Icon(Icons.add),
                  label: const Text('Add to My Library'),
                ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WriteReviewScreen(bookId: widget.book['id']),
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
                    builder: (_) => ReviewDetailsScreen(bookId: widget.book['id']),
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
