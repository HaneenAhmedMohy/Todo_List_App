import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonGradientButtonWidget extends StatelessWidget {
  final Function onPressFunction;
  final double width;
  final String title;
  final double radius;
  const CommonGradientButtonWidget(
      {super.key,
      required this.onPressFunction,
      required this.width,
      required this.title,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: () => onPressFunction(),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
