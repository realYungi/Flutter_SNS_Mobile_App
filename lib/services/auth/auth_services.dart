import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential> signInWithEmailPasword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
        return userCredential;


    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );
        return userCredential;

    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


}