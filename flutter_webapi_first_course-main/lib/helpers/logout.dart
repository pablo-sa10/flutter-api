import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Logout(BuildContext context) {
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
    Navigator.pushReplacementNamed(context, "login");
  });
}