import 'package:creiden_task/Controllers/auth_controller.dart';
import 'package:creiden_task/View/Screens/list_screen.dart';
import 'package:creiden_task/View/Screens/login_screen.dart';
import 'package:creiden_task/View/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  checkLoginStatus() async {
    String? userId = await Future.delayed(
        const Duration(seconds: 2), () => AuthController().getUserID());
    if (userId != null && userId.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Show the splash screen while checking login status
          return const SplashScreen();
        } else {
          // Check if the user is logged in
          if (snapshot.data == true) {
            return const TodoListScreen();
          } else {
            // User is not logged in, show the login screen
            return const LoginScreen();
          }
        }
      },
    );
  }
}
