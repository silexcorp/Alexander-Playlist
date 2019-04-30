import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silexcorp/source/utils/auth.dart';
import 'package:silexcorp/source/utils/state.dart';
import 'package:silexcorp/source/utils/userdata.dart';

class StateWidget extends StatefulWidget {

  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {

  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> verifyUser() async {
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    var userQuery = await Firestore.instance.collection('users').where('uid', isEqualTo: firebaseUser.uid).limit(1);
    print('########################### UD ' + firebaseUser.uid);
    userQuery.getDocuments().then((data) async {
      if(data.documents.length > 0){
        /*setState((){ firstName = data.documents[0].data['firstName']; });*/
        UserData userData = new UserData();
        //userData.level = data.documents[0].data['level'];
        userData.name = firebaseUser.displayName;
        setState(() {
          state.isLoading = false;
          state.userData = userData;
        });
      }else{
        await Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'uid': firebaseUser.uid,
          'name': firebaseUser.displayName,
          'email': firebaseUser.email,
          'active': true,
        });
        setState(() {
          state.isLoading = false;
        });
      }
    });
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    //UserData userData = new UserData();
    setState(() {
      //state.isVerifyingRegister = true;
      verifyUser();
      state.userFirebase = firebaseUser;
    });
  }

  Future<Null> signOutOfGoogle() async {
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state.userData = null;
    state.userFirebase = null;
    setState(() {
      state = StateModel(userFirebase: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}