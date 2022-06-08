import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_config.dart';

import '../../../entities/home_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../../utils/item_widget/item_product.dart';

class ProductsWidget extends StatelessWidget {
  final FeaturedProducts? featuredProducts;
  final String? title;
  final String? moreText;

  const ProductsWidget({Key? key, required this.featuredProducts, this.title, this.moreText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (featuredProducts?.display == false ||
            featuredProducts?.items == null ||
            featuredProducts?.items?.length == 0)
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget , horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomText(
                            featuredProducts?.title ?? title,
                            fontSize: 17,
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (featuredProducts?.moreButton != null || moreText != null)
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                if (AppConfig.isSoreUseNewTheme) {
                                  if (featuredProducts?.url != null) {
                                    goToLink(featuredProducts?.url);
                                  } else if(featuredProducts?.id != null && featuredProducts?.id != 'null'){
                                    Get.toNamed('/category-details/${featuredProducts?.id}');
                                  }else{
                                    Get.toNamed('/category-details/arguments', arguments: {
                                      'name': featuredProducts?.title ?? '',
                                      'filter': featuredProducts?.moduleType,
                                    });
                                  }
                                } else {
                                  Get.toNamed('/category-details/arguments', arguments: {
                                    'name': featuredProducts?.title ?? '',
                                    'filter': featuredProducts?.moreButton?.url,
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: CustomText(moreText ?? "عرض الكل".tr,
                                          textAlign: TextAlign.end,
                                          maxLines: 1,
                                          color: primaryColor)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RotationTransition(
                                      turns: AlwaysStoppedAnimation(
                                          (isArabicLanguage ? 180 : 0) / 360),
                                      child: Image.asset(iconBack, color: primaryColor, scale: 2)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio:
                    featuredProducts?.items?.length == 2 || featuredProducts?.items?.length == 1
                        ? 1.18
                        : 1.32,
                child: ListView.builder(
                    itemCount: featuredProducts?.items?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ItemProduct(featuredProducts!.items![index],
                        width: featuredProducts?.items?.length == 2 ||
                                featuredProducts?.items?.length == 1
                            ? 166
                            : 140,
                        backCount: 1,
                        horizontal: true)),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
  }
}
