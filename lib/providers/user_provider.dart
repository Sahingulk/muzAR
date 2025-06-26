import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  Future<void> loadUser() async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) {
      _user = AppUser(
        uid: current.uid,
        email: current.email ?? '',
        displayName: current.displayName,
      );
      notifyListeners();
    }
  }
}
