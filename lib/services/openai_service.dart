import 'dart:convert';
import 'package:http/http.dart' as http;
import '../secrets.dart';

class OpenAIService {
  final _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> summarizeReviews(List<String> reviews) async {
    final prompt = 'Summarize the following user reviews in 2-3 sentences:\n\n' + reviews.join('\n\n');

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $openAIKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      return 'Failed to summarize reviews.';
    }
  }

  Future<String> analyzeSentiment(String reviewText) async {
    final prompt = 'Label the overall sentiment (Positive, Neutral, or Negative) of the following review:\n\n"$reviewText"';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $openAIKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.2,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print("OpenAI Error: ${response.statusCode} - ${response.body}");
      return 'Failed to summarize reviews.';
    }
  }
}
