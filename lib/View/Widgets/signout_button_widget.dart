import 'package:creiden_task/View/Providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignoutButtonWidget extends StatelessWidget {
  const SignoutButtonWidget({super.key});
  Future<void> signOutAction(context) async {
    Navigator.pop(context);
    await Provider.of<AuthProvider>(context, listen: false).signOut(context);
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to sign out?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                  'Please note that all your todos will be deleted after signing out'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                signOutAction(context);
              },
              child: const Text(
                'Sign out',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPopUpDialog(context),
      child: Text(
        'Sign out',
        style: TextStyle(fontSize: 18.sp, color: Colors.red),
      ),
    );
  }
}
