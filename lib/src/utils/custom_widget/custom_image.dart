import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import '../../images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double size;
  final BoxFit? fit;
  final bool showErrorImage;
  final bool loading;

  const CustomImage(
      {Key? key,
      required this.url,
      this.height,
      this.width,
      this.size = 65,
      this.loading = true,
      this.showErrorImage = true,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url?.contains('svg') == true) {
      if (url?.contains('tabby2') == true) {
        return Image.asset(iconTabby2);
      }
      if (url?.contains('tamara2') == true) {
        return Image.asset(iconTamara2);
      }
      return SvgPicture.network(url ?? '',
          height: height?.h,
          width: width?.w,
          allowDrawingOutsideViewBox: true,
          fit: fit ?? BoxFit.contain,
          placeholderBuilder: (BuildContext context) => showErrorImage
              ? Image.asset(
                  iconLogoFull,
                  width: size.sp,
                  height: size.sp,
                )
              : const SizedBox());
    }
    return CachedNetworkImage(
      height: height?.h,
      width: width?.w,
      fit: fit ?? BoxFit.contain,
      imageUrl: url ?? '',
      alignment: Alignment.topCenter,
      placeholder: (context, url) => loading
          ? const SizedBox(
              width: 25,
              height: 25,
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
              )))
          : const SizedBox(),
      errorWidget: (context, url, error) => Padding(
        padding: EdgeInsets.all(size / 2),
        child: showErrorImage
            ? Image.asset(
                iconLogoFull,
                width: size.sp,
                height: size.sp,
              )
            : const SizedBox(),
      ),
    );
  }
}
