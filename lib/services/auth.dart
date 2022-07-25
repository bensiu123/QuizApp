import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      print('signInWithGoogle');
      final googleUser = await GoogleSignIn(
        clientId: Platform.isIOS
            ? '775118302580-m6361s2v9nl2lkeb2bisdjqf65ggg37p.apps.googleusercontent.com'
            : null,
      ).signIn();
      print(googleUser);

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      print(googleAuth);
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(authCredential);

      if (user != null) {
        await user?.linkWithCredential(authCredential);
      } else {
        await FirebaseAuth.instance.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
