import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;
  // Try to sign in the previous user:
  if (account == null) {
    account = await googleSignIn.signInSilently();
  }
  return account;
}

Future<FirebaseUser> signIntoFirebase(GoogleSignInAccount googleAccount) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

  AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = await _auth.signInWithCredential(credential);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  return user;
}
