import 'package:creiden_task/Apis/auth_api.dart';
import 'package:creiden_task/Controllers/auth_controller.dart';
import 'package:creiden_task/Controllers/notification_controller.dart';
import 'package:creiden_task/Controllers/todo_storage_controller.dart';
import 'package:creiden_task/routes.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // STATES
  String loginErrorMessage = '';
  bool isLoading = false;

  void loginWithEmailAndPassword(
      String? email, String? password, context) async {
    isLoading = true;
    loginErrorMessage = '';
    notifyListeners();
    bool response = await AuthApi().loginUser(email: email, password: password);
    isLoading = false;
    notifyListeners();
    if (response) {
      Routes.navigateToScreen(
          Routes.listScreen, NavigateType.PUSH_REPLACEMENT_NAMED, {}, context);
    } else {
      loginErrorMessage = 'Login Failed';
      notifyListeners();
    }
  }

  Future<void> signOut(context) async {
    await AuthController().saveUserID('');
    await NotificationController().clearAll();
    await TodoStorageController().deleteAllTodosItem();
    Routes.navigateToScreen(
        Routes.loginScreen, NavigateType.PUSH_REPLACEMENT_NAMED, {}, context);
  }
}
