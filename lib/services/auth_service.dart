import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kcmdemo/models/auth_user.dart';
import 'package:kcmdemo/services/kcm_service.dart';

class AuthService{

  //TODO::Initializing FirebaseAuth & GoogleSignIn
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //TODO::Handle sign-in with google
  Future<void> handleSignIn() async {
    try{
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if(googleSignInAccount != null){
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(authCredential);

        //TODO::Initializing AuthUser with set data of user
        AuthUser authUser = AuthUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          score: 0
        );

        //TODO::Initializing KcmService with check if exist in Firestore
        //TODO::If not exist store in Firestore
        KcmService kcmService = KcmService();
        kcmService.checkExistUserInFirestoreWithStoreIfNotExist(authUser);

      }
    }catch(e){
      print('Error system ${e.toString()}');
    }
  }

  //TODO::Handle sign-out
  Future<void> handleSignOut() async {
    try{
      await _googleSignIn.signOut();
      await _auth.signOut();
    }catch(e){
      print('Error system ${e.toString()}');
    }
  }



}