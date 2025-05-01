import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateGenres(List<String> genres) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update({
        'preferredGenres': genres,
      });
    }
  }
}
