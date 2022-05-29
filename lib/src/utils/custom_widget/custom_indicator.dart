import '../../colors.dart';
import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {

  final bool isActive;

  const CustomIndicator(this.isActive , {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 7,
      width:  isActive ? 30 : 7,
      decoration: BoxDecoration(
        color: isActive ? greenLightColor : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
