import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;//current user returned from fireabse auth
  Observable<Map<String,dynamic>> profile;//data stored about the user
  PublishSubject loading = PublishSubject();

  AuthService(){
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u){
      if(u != null){
        return _db.collection('users').document(u.uid).snapshots().map((snap) =>snap.data);
      }else{
        return Observable.just({});
      }
    });

  }

  // Future<FirebaseUser> googleSignIn() async {

  //   loading.add(true);
  //   GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //   FirebaseUser user = await _auth.signInWithGoogle(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken
  //   );

  //   updateUserData(user);
  //   loading.add(false);
  //   return user;
  // }

  Future<String> _testSignInWithGoogle() async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();

    return 'signInWithGoogle succeeded: $user';
  }

    Future<FirebaseUser> signInWithGoogle() async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    updateUserData(user);
    return currentUser;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid':user.uid,
      'email': user.email,
      'lastSeen': DateTime.now(),
    }, merge:true);
    }



  void signOut(){
    _auth.signOut();
  }
}

final AuthService authService = AuthService();