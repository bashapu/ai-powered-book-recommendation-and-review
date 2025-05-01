import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';

class ReviewService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> submitReview(ReviewModel review) async {
    await _firestore
        .collection('books')
        .doc(review.bookId)
        .collection('reviews')
        .add(review.toMap());
  }

  Stream<List<ReviewModel>> getReviews(String bookId) {
    return _firestore
        .collection('books')
        .doc(bookId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data())).toList());
  }
}
