import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final userFormKey = GlobalKey<FormState>();
  bool _isUser = false;

  bool get isUser => _isUser;

  void loginUser() {
    _isUser = true;
    notifyListeners();
  }

  void logoutUser() {
    _isUser= false;
    notifyListeners();
  }

}
