import 'package:entaj/src/colors.dart';
import 'package:entaj/src/entities/module_model.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturesWidget extends StatelessWidget {
  final List<StoreFeatures> storeFeatures;
  final String? bgColor;

  const FeaturesWidget({Key? key, required this.storeFeatures, this.bgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: bgColor == null ?primaryColor : HexColor.fromHex(bgColor!),
      width: double.infinity,
      child: Row(
        children: storeFeatures
            .map((e) => Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomImage(url: e.image),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomText(
                        e.title,
                        fontSize: 12,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        color: HexColor.fromHex(e.text_color??'#000000'),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
