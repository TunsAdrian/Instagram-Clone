import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/src/models/index.dart';
import 'package:instagram_clone/src/data/index.dart';
import 'package:meta/meta.dart';

class AuthApi {
  const AuthApi({
    @required FirebaseAuth auth,
    @required FirebaseFirestore firestore,
    @required GoogleSignIn google,
  })  : assert(auth != null),
        assert(firestore != null),
        assert(google != null),
        _auth = auth,
        _firestore = firestore,
        _google = google;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _google;

  Future<AppUser> getCurrentUser() async {
    final User user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final DocumentSnapshot snapshot = await _firestore.doc('users/${user.uid}').get();
    return AppUser.fromJson(snapshot.data());
  }

  Future<AppUser> login({@required String email, @required String password}) async {
    final UserCredential response = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = response.user;

    final DocumentSnapshot snapshot = await _firestore.doc('users/${user.uid}').get();
    return AppUser.fromJson(snapshot.data());
  }

  Future<AppUser> signUp({@required String email, @required String password, @required String username}) async {
    final UserCredential response = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = response.user;

    final AppUser appUser = AppUser((AppUserBuilder b) {
      b
        ..uid = user.uid
        ..email = user.email
        ..username = username
        ..searchIndex = ListBuilder<String>(<String>[username].searchIndex);
    });

    await _firestore.doc('users/${user.uid}').set(appUser.json);
    return appUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<AppUser> signUpWithGoogle() async {
    // sign in with google
    final GoogleSignInAccount googleAccount = await _google.signIn();
    if (googleAccount == null) {
      return null;
    }

    final GoogleSignInAuthentication authentication = await googleAccount.authentication;

    // create/login with google credential
    final OAuthCredential credential =
        GoogleAuthProvider.credential(idToken: authentication.idToken, accessToken: authentication.accessToken);

    final UserCredential response = await _auth.signInWithCredential(credential);
    final User user = response.user;

    final DocumentSnapshot snapshot = await _firestore.doc('users/${user.uid}').get();
    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.data());
    }

    final AppUser appUser = AppUser((AppUserBuilder b) {
      b
        ..uid = user.uid
        ..email = user.email
        ..username = user.email.split('@').first
        ..photoUrl = user.photoURL
        ..searchIndex = ListBuilder<String>(<String>[user.email.split('@').first].searchIndex);
    });

    await _firestore.doc('users/${user.uid}').set(appUser.json);
    return appUser;
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<List<AppUser>> searchUsers(String query) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users') //
        .where('searchIndex', arrayContains: query)
        .get();

    return snapshot.docs //
        .map((QueryDocumentSnapshot snapshot) => AppUser.fromJson(snapshot.data()))
        .toList();
  }

  Future<void> updateFollowing({@required String uid, String add, String remove}) async {
    FieldValue value;
    if (add != null) {
      value = FieldValue.arrayUnion(<String>[add]);
    } else {
      value = FieldValue.arrayRemove(<String>[remove]);
    }

    await _firestore.doc('users/$uid').update(<String, dynamic>{'following': value});
  }

  Future<AppUser> getUser(String uid) async {
    final DocumentSnapshot doc = await _firestore.doc('users/$uid').get();
    return AppUser.fromJson(doc.data());
  }
}
