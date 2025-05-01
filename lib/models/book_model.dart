class BookModel {
  final String id;
  final String title;
  final String authors;
  final String status;
  final String? thumbnail;
  final String? description;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.status,
    this.thumbnail,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'status': status,
      'thumbnail': thumbnail,
      'description': description,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      authors: map['authors'],
      status: map['status'],
      thumbnail: map['thumbnail'],
      description: map['description'],
    );
  }
}
