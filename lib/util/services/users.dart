import 'package:flutter/material.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///Users
class Users {
  ///Supabase Instance
  static final _supabase = Supabase.instance.client;

  ///Current User
  static final User? currentUser = _supabase.auth.currentUser;

  ///Sign In
  static Future<void> signIn({
    required String email,
    required String password,
    required VoidCallback onSignedIn,
  }) async {
    //Attempt to Sign In
    try {
      //Sign In
      await _supabase.auth
          .signInWithPassword(
        email: email,
        password: password,
      )
          .then(
        (authResponse) async {
          if (authResponse.user != null) {
            //Cache User
            await cacheUser(user: authResponse.user!);

            //On Sign-In
            onSignedIn();
          }
        },
      );
    } on AuthException catch (error) {
      LocalNotifications.toast(message: error.message);
    }
  }

  ///Create Account
  static Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required VoidCallback onSignUp,
  }) async {
    //Attempt to Create Account
    try {
      //Create Account
      await _supabase.auth.signUp(email: email, password: password, data: {
        "username": username,
      }).then((authResponse) async {
        if (authResponse.user != null) {
          //Add User to Database
          await _supabase.from("users").insert({
            "id": authResponse.user!.id,
            "username": username,
          });

          //Cache User
          await cacheUser(user: authResponse.user!);

          //On Sign-Up
          onSignUp();
        }
      });
    } on AuthException catch (error) {
      LocalNotifications.toast(message: error.message);
    }
  }

  ///Cache User
  static Future<void> cacheUser({required User user}) async {
    await LocalData.setData(box: "user", data: {
      "id": user.id,
      "username": user.userMetadata?["username"] ?? "",
    });
  }

  ///Get Username by UserID
  static Future<String> usernameByID({required String userID}) async {
    //Users
    final users = await _supabase.from("users").select().eq("id", userID);

    //Return Username
    return users.first["username"];
  }
}
