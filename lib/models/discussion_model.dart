import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionThread {
  final String id;
  final String title;
  final String createdBy;
  final String genre;
  final DateTime timestamp;

  DiscussionThread({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.genre,
    required this.timestamp,
  });

  factory DiscussionThread.fromMap(String id, Map<String, dynamic> data) {
    return DiscussionThread(
      id: id,
      title: data['title'],
      createdBy: data['createdBy'],
      genre: data['genre'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

class DiscussionPost {
  final String text;
  final String author;
  final DateTime timestamp;

  DiscussionPost({
    required this.text,
    required this.author,
    required this.timestamp,
  });

  factory DiscussionPost.fromMap(Map<String, dynamic> data) {
    return DiscussionPost(
      text: data['text'],
      author: data['author'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
