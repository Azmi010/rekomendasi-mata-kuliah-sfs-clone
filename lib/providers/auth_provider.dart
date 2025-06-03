import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sfs/models/user_data.dart';
import 'package:sfs/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  UserData? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  UserData? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor menerima instance AuthService
  // AuthProvider(this._authService) {
  //   _authService.authStateChanges.listen((User? firebaseUser) {
  //     _user = firebaseUser;
  //     _isLoading = false;
  //     notifyListeners();
  //   });
  // }
  AuthProvider(this._authService) {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    if (firebaseUser != null) {
      await _fetchUserData(firebaseUser.uid); // Ambil UserData jika user login
    } else {
      _userData = null; // Kosongkan UserData jika logout
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    
    try {
      _userData = await _authService.getUserProfile();
    } catch (e) {
      _errorMessage = "Gagal memuat data profil: ${e.toString()}";
      _userData = null;
      print("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _isLoading = false;
    notifyListeners();
  }
}