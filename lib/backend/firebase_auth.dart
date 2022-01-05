import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);


  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn({required String email, required String password})  async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
  
  Future<String?> resetPassword({required String email}) async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
  }


  Future<void> signUp({required String email,required String password}) async {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }
}