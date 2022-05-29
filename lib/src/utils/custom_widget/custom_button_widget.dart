import '../../colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text.dart';

class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  final Widget icon;
  final bool loading;
  final Color? color;
  final Color textColor;
  final double padding;
  final double height;
  final double width;
  final double? widthBorder;
  final double elevation;
  final double radius;
  final double textSize;

  const CustomButtonWidget(
      {required this.title,
        required this.onClick,
        this.loading = false,
        this.color = primaryColor,
        this.textColor = Colors.white,
        this.width = double.infinity,
        this.widthBorder,
        this.height = 46,
        this.textSize = 14,
        this.radius = 15,
        this.elevation = 0,
        this.icon = const SizedBox(),
        this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height.h,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          elevation: elevation,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          shape: RoundedRectangleBorder(
              side: widthBorder == null
                  ? BorderSide.none
                  : BorderSide(color: textColor, width: widthBorder!),
              borderRadius: BorderRadius.circular(radius)),
        ),
        onPressed: loading ? null : onClick,
        child: loading != null && loading == true
            ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade100))
            : Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            icon,
            Expanded(
              child: CustomText(
                title,
                fontSize: textSize,
                textAlign: TextAlign.center,
                color: textColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
