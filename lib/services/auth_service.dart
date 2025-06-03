import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    DocumentSnapshot userDoc = await _userRepository.fetchUserDocument(_userId!);
    if (!userDoc.exists) throw Exception('Data pengguna tidak ditemukan.');
    return UserData.fromMap(_userId!, userDoc.data() as Map<String, dynamic>);
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