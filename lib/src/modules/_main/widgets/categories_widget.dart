import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors.dart';
import '../../../utils/item_widget/item_home_category.dart';
import '../logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        id: "categories",
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return logic.isCategoriesLoading
              ? Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: SizedBox(
                    height: 38.h,
                    child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => const ItemHomeCategory(null)),
                  ))
              : false
                  ? Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      height: logic.homeScreenOldThemeModel?.payload?.menu?.items?.isEmpty == true
                          ? 0
                          : 38.h,
                      child: ListView.builder(
                          itemCount:
                              logic.homeScreenOldThemeModel?.payload?.menu?.items?.length ?? 0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => ItemHomeCategory(
                              logic.homeScreenOldThemeModel?.payload?.menu?.items?[index])),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
                      height: logic.categoriesList.isEmpty ? 0 : 38.h,
                      child: ListView.builder(
                          itemCount: logic.categoriesList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              ItemHomeCategory(logic.categoriesList[index])),
                    );
        });
  }
}
