import 'package:creiden_task/View/Providers/auth_provider.dart';
import 'package:creiden_task/View/Widgets/common_gradient_button.dart';
import 'package:creiden_task/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    Provider.of<AuthProvider>(context, listen: false)
        .loginWithEmailAndPassword(email, password, context);
  }

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
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.w, top: 120.h),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 32.sp, color: Colors.black),
              ),
            ),
            PositionedDirectional(
              bottom: 0,
              child: Container(
                height: 600.h,
                width: 375.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          'Email*',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter your email",
                            fillColor: Colors.grey[30],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Password*',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "Enter your Passsword",
                            fillColor: Colors.grey[30],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Selector<AuthProvider, bool>(
                            selector: (_, provider) => provider.isLoading,
                            builder: (_, isLoading, __) {
                              if (isLoading) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.w,
                                    height: 50.h,
                                    child: const CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return CommonGradientButtonWidget(
                                  onPressFunction: () => _login(),
                                  title: 'Sign In',
                                  width: 350,
                                  radius: 20,
                                );
                              }
                            }),
                        Selector<AuthProvider, String>(
                            selector: (_, provider) =>
                                provider.loginErrorMessage,
                            builder: (_, loginErrorMessage, __) {
                              if (loginErrorMessage.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    loginErrorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return Container();
                            }),
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
