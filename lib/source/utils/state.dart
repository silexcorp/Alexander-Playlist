import 'package:firebase_auth/firebase_auth.dart';
import 'package:silexcorp/source/utils/userdata.dart';

class StateModel {
  bool isLoading;
  FirebaseUser userFirebase;
  UserData userData;


  StateModel({
    this.isLoading = false,
    this.userFirebase,
    this.userData,
  });
}