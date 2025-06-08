import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/models/user_data.dart';
import 'package:sfs/repositories/user_repository.dart';

class AuthService {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? get _userId => _firebaseAuth.currentUser?.uid;

  AuthService(this._userRepository);

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserData> getUserProfile() async {
    if (_userId == null) throw Exception("Pengguna belum login.");

    final results = await Future.wait([
      _userRepository.fetchUserDocument(_userId!),
      _userRepository.fetchSelectedCourses(_userId!),
    ]);
    
    final userDoc = results[0] as DocumentSnapshot;
    final coursesSnapshot = results[1] as QuerySnapshot;

    if (!userDoc.exists) throw Exception('Data pengguna tidak ditemukan.');

    UserData userData = UserData.fromMap(_userId!, userDoc.data() as Map<String, dynamic>);

    final List<SelectedCourseDetail> courses = coursesSnapshot.docs.map((doc) {
      return SelectedCourseDetail.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();

    return userData.copyWith(courses: courses);
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}