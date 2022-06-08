import 'package:entaj/src/colors.dart';
import 'package:entaj/src/entities/module_model.dart';
import 'package:entaj/src/utils/custom_widget/custom_image.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_config.dart';

class FeaturesWidget extends StatelessWidget {
  final List<StoreFeatures> storeFeatures;
  final String? bgColor;

  const FeaturesWidget({Key? key, required this.storeFeatures, required this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      color: bgColor != null ? HexColor.fromHex(bgColor!) : featuresBackgroundColor,
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
                        child: CustomImage(
                          url: e.image,
                          width: AppConfig.featureSize,
                          height: AppConfig.featureSize,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomText(
                        e.title,
                        fontSize: 12,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        color: e.textColor != null
                            ? HexColor.fromHex(e.textColor!)
                            : featuresForegroundColor,
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
