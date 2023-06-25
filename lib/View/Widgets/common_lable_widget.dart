import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonLabelWidget extends StatelessWidget {
  final String title;
  const CommonLabelWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child:
          Text(title, style: TextStyle(fontSize: 16.sp, color: Colors.black54)),
    );
  }
}
