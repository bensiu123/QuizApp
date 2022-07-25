import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

      await (user?.linkWithCredential(authCredential) ??
          FirebaseAuth.instance.signInWithCredential(authCredential));

      // if (user != null) {
      //   await user?.linkWithCredential(authCredential);
      // } else {
      //   await FirebaseAuth.instance.signInWithCredential(authCredential);
      // }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (index) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await (user?.linkWithCredential(oauthCredential) ??
        FirebaseAuth.instance.signInWithCredential(oauthCredential));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
