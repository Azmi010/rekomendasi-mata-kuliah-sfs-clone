import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<DocumentSnapshot> fetchUserDocument(String userId) async {
    return _firestore.collection('users').doc(userId).get();
  }
}