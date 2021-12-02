import 'package:firebase_auth/firebase_auth.dart';
import 'package:genesis/models/User.dart';
import 'package:genesis/services/database.dart';

class AuthentificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser _userFromFirebase(User? user){
    if (user != null) {
      return AppUser(uid: user.uid);
    }else{
      // ignore: null_check_always_fails
      return null!;
    }
  }

  Stream<AppUser> get user{
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      return null;
    }
  }
  
  Future registerWithEmailAndPassword(String name, String pseudo, String age,  String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await DatabaseService(user!.uid).saveUser(name, pseudo, age, 'active');
      return _userFromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future sOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
