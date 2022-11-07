import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_1/firestore/firestore_list_screen.dart';
import 'package:first_project_1/ui/auth/login_screen.dart';
import 'package:first_project_1/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {

    // First we will create the instance of firebase auth
    final auth = FirebaseAuth.instance;

    // Then we check the user is already there in the auth or not

  // It give us the current logged in user detail
    final user = auth.currentUser;
  
  if(user != null)
  {
    // If user is not equal to null thats mean user in logg in
    // Then we will take user to the post screen

        Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => FirestoreScreen())));

  }
  else
  {
        Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));

  }

    


  }
}
