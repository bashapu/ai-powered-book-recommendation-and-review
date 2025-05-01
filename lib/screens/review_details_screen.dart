import 'package:flutter/material.dart';
import '../services/review_service.dart';
import '../models/review_model.dart';

class ReviewDetailsScreen extends StatelessWidget {
  final String bookId;

  const ReviewDetailsScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: StreamBuilder<List<ReviewModel>>(
        stream: ReviewService().getReviews(bookId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final reviews = snapshot.data!;
          if (reviews.isEmpty) return const Center(child: Text('No reviews yet.'));

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (_, i) {
              final r = reviews[i];
              return ListTile(
                title: Text('${r.rating} ⭐ - ${r.reviewerEmail}'),
                subtitle: Text(r.reviewText),
              );
            },
          );
        },
      ),
    );
  }
}
