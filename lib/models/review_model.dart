class ReviewModel {
  final String userId;
  final String bookId;
  final String reviewText;
  final double rating;
  final String reviewerEmail;

  ReviewModel({
    required this.userId,
    required this.bookId,
    required this.reviewText,
    required this.rating,
    required this.reviewerEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'reviewText': reviewText,
      'rating': rating,
      'reviewerEmail': reviewerEmail,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      userId: map['userId'],
      bookId: map['bookId'],
      reviewText: map['reviewText'],
      rating: map['rating'].toDouble(),
      reviewerEmail: map['reviewerEmail'],
    );
  }
}
