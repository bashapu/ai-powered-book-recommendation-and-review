import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';
import '../services/openai_service.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final String bookId;

  const ReviewDetailsScreen({super.key, required this.bookId});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  final _openAI = OpenAIService();
  String? _summary;
  List<String> _sentiments = [];

  Future<void> _processReviews(List<ReviewModel> reviews) async {
    if (reviews.isEmpty) return;
    final texts = reviews.map((r) => r.reviewText).toList();

    final summary = await _openAI.summarizeReviews(texts);

    final sentiments = await Future.wait(texts.map((t) => _openAI.analyzeSentiment(t)));

    setState(() {
      _summary = summary.contains('Failed') ? null : summary;
      _sentiments = sentiments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: StreamBuilder<List<ReviewModel>>(
        stream: ReviewService().getReviews(widget.bookId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final reviews = snapshot.data!;
          if (_summary == null && reviews.isNotEmpty) {
            _processReviews(reviews);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_summary != null) ...[
                const Text('Summary of Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_summary!),
                const Divider(height: 32),
              ],
              const Text('Individual Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (int i = 0; i < reviews.length; i++)
                ListTile(
                  title: Text('${reviews[i].rating}⭐ by ${reviews[i].reviewerEmail}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reviews[i].reviewText),
                      if (_sentiments.length > i)
                        Text('Sentiment: ${_sentiments[i]}',
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.deepPurple)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
