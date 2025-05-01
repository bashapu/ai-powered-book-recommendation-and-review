import 'package:flutter/material.dart';
import '../services/review_service.dart';
import '../models/review_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteReviewScreen extends StatefulWidget {
  final String bookId;

  const WriteReviewScreen({super.key, required this.bookId});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _controller = TextEditingController();
  double _rating = 3.0;
  final _auth = FirebaseAuth.instance;

  void _submit() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final review = ReviewModel(
      userId: user.uid,
      bookId: widget.bookId,
      reviewText: _controller.text.trim(),
      rating: _rating,
      reviewerEmail: user.email ?? 'Anonymous',
    );

    await ReviewService().submitReview(review);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Your Rating'),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (value) => setState(() => _rating = value),
            ),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: const Text('Submit Review')),
          ],
        ),
      ),
    );
  }
}
