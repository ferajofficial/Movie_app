import 'dart:ffi';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie/utils/import.dart';

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: kSecondaryColor,
      //shape: CircleBorder,
      content: Text(
        "Enter Valid Email & Password",
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
      ),
    ),
  );
}

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

//* ======= Email Signup ====== */

  Future<Void?> signUpWithEmail({
    required String email,
    required String password,
    // required String name,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!.toString());
    }
    return null;
  }

//* ======= Email Verification ====== */

  Future<Void?> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackbar(context, 'The email verification has been sent.');
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!.toString());
    }
    return null;
  }

//* ======= Email Login ====== */

  Future<Void?> loginWithEmail({
    required String email,
    required String password,
    // required String name,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!.toString());
    }
    return null;
  }

//* ======= Google Signin ====== */

  Future<Void?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleuser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {}
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!.toString());
    }
    return null;
  }
}
