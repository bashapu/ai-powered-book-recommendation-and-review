class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> preferredGenres;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.preferredGenres,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'preferredGenres': preferredGenres,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '', // fallback to empty string
      name: map['name'] ?? 'Unknown',
      email: map['email'] ?? 'no-email@example.com',
      preferredGenres:
          map['preferredGenres'] != null
              ? List<String>.from(map['preferredGenres'])
              : [],
    );
  }
}
