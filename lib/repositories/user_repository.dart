import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> fetchUserDocument(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  Future<QuerySnapshot> fetchSelectedCourses(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .get();
  }
}