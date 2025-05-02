import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/discussion_model.dart';

class CommunityService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<DiscussionThread>> getThreads() {
    return _firestore.collection('discussion_threads').orderBy('timestamp', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((doc) => DiscussionThread.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> createThread(String title, String genre, String userEmail) async {
    await _firestore.collection('discussion_threads').add({
      'title': title,
      'genre': genre,
      'createdBy': userEmail,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<DiscussionPost>> getPosts(String threadId) {
    return _firestore
        .collection('discussion_threads')
        .doc(threadId)
        .collection('posts')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => DiscussionPost.fromMap(doc.data())).toList());
  }

  Future<void> addPost(String threadId, String text, String author) async {
    await _firestore.collection('discussion_threads').doc(threadId).collection('posts').add({
      'text': text,
      'author': author,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
