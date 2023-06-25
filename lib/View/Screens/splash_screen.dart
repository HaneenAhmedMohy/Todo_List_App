import 'package:creiden_task/View/Providers/auth_provider.dart';
import 'package:creiden_task/View/Widgets/common_gradient_button.dart';
import 'package:creiden_task/app_assets.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.login_background_image),
                  fit: BoxFit.cover)),
          child: Center(
            child: Text(
              'TODO APP SPLASH SCREEN',
              style: TextStyle(fontSize: 24),
            ),
          )),
    );
  }
}
