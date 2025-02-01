import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if the user is authenticated and email is verified
  bool get isAuthenticated =>
      _auth.currentUser != null && _auth.currentUser!.emailVerified;

  // Login with email and password
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        throw Exception("Email is not verified. Please verify your email.");
      }
    } catch (e) {
      throw e;
    }
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();
  }
}