import 'package:entaj/src/utils/functions.dart';

import '../../../app_config.dart';
import '../../../entities/home_screen_model.dart';
import '../../../entities/module_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import 'package:flutter/material.dart';
import '../../../colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnersWidget extends StatelessWidget {
  final String? title;
  final List<Items>? gallery;

  const PartnersWidget({Key? key, required this.title, required this.gallery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (gallery == null || gallery?.length == 0)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title ?? 'fksmfldmsfd',
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                      itemCount: gallery?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () => goToLink(gallery?[index].url),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: CustomImage(
                                url: gallery?[index].image,
                                width: 100,
                              ),
                            ),
                          )),
                )
              ],
            ),
          );
  }
}
