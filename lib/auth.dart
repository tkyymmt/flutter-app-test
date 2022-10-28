import 'package:firebase_auth/firebase_auth.dart';

Future<String> authUser(
    {required String email, required String password}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return '';
  } on FirebaseAuthException catch (e) {
    return e.code;
  }
}
