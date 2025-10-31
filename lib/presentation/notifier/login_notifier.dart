import 'package:flutter/material.dart';

class LoginNotifier extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void login(String email, String password) async {
    if (isLoading) return;
    setLoading(true);
    // Simulate a login process with a delay
    await Future.delayed(const Duration(seconds: 2));
    // Here you would typically call your authentication service
    setLoading(false);
  }
}
