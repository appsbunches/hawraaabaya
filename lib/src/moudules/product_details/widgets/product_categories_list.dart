import 'package:entaj/src/app_config.dart';
import 'package:entaj/src/colors.dart';
import 'package:entaj/src/entities/category_model.dart';
import 'package:flutter/foundation.dart';

import '../logic.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductCategoriesList extends StatefulWidget {
  const ProductCategoriesList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductCategoriesList> createState() => _ProductCategoriesListState();
}

class _ProductCategoriesListState extends State<ProductCategoriesList> {
  final ProductDetailsLogic logic = Get.find();
  bool clicked = false;
  List<GlobalKey> listGlobalKey = [];

  @override
  Widget build(BuildContext context) {
    return !AppConfig.enhancementsV1
        ? GetBuilder<ProductDetailsLogic>(
            init: Get.find<ProductDetailsLogic>(),
            builder: (logic) {
              return SizedBox(
                height: (logic.productModel?.categories?.length ?? 0) == 0 ? 0 : 30.h,
                child: ListView.builder(
                    itemCount: logic.productModel?.categories?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.toNamed(
                                  "/category-details/${logic.productModel?.categories?[index].id}"),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.sp),
                                      color: Colors.grey.shade400),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  child: CustomText(
                                    logic.productModel?.categories?[index].name,
                                    fontSize: 10,
                                  )),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        )),
              );
            })
        : GetBuilder<ProductDetailsLogic>(
            init: Get.find<ProductDetailsLogic>(),
            builder: (logic) {
              calculateRemCategories(logic.productModel?.categories ?? []);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText('التصنيفات'.tr),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: logic.productModel?.categories
                                  ?.sublist(
                                      0,
                                      ((logic.productModel?.categories?.length ?? 0) > 3)
                                          ? 3
                                          : logic.productModel?.categories?.length)
                                  .map(
                                    (e) => Flexible(
                                      child: GestureDetector(
                                        onTap: () => Get.toNamed("/category-details/${e.id}"),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.sp),
                                                color: categoryProductDetailsBackgroundColor),
                                            margin: const EdgeInsetsDirectional.only(end: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            child: CustomText(
                                              '${e.name}',
                                              color: categoryProductDetailsTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            )),
                                      ),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ),
                      if (false)
                        Expanded(
                          child: RichText(
                            maxLines: 1,
                            text: TextSpan(
                                children: logic.productModel?.categories
                                        ?.map((e) => WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Get.toNamed("/category-details/${e.id}"),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.sp),
                                                        color:
                                                            categoryProductDetailsBackgroundColor),
                                                    margin:
                                                        const EdgeInsetsDirectional.only(end: 10),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 4),
                                                    child: CustomText(
                                                      e.name,
                                                      color: categoryProductDetailsTextColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    )),
                                              ),
                                            ))
                                        .toList() ??
                                    []),
                          ),
                        ),
                      if (categoriesNum != 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PopupMenuButton(
                              color: primaryColor,
                              padding: EdgeInsets.zero,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              itemBuilder: (context) {
                                return List.generate(categoriesNum, (index) {
                                  var e = logic.productModel?.categories?[index +
                                      ((logic.productModel?.categories?.length ?? 0) -
                                          categoriesNum)];
                                  return PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Get.toNamed("/category-details/${e?.id}"),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomText(
                                              e?.name,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        if (index != categoriesNum - 1)
                                          Container(
                                              height: 1,
                                              color: Colors.white30,
                                              width: double.infinity)
                                      ],
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.sp),
                                      color: categoryProductDetailsBackgroundColor),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  child: CustomText(
                                    '$categoriesNum+',
                                    color: categoryProductDetailsTextColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ), /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              height: clicked ? null : 0,
                              width: 120.w,
                              margin: EdgeInsets.only(top: 40.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: primaryColor.withOpacity(0.7)),
                              child: Column(
                                children: logic.productModel?.categories
                                        ?.sublist(
                                            (logic.productModel?.categories?.length ?? 0) -
                                                categoriesNum,
                                            logic.productModel?.categories?.length)
                                        .map((e) => Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      Get.toNamed("/category-details/${e.id}"),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: CustomText(
                                                      e.name,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                if (logic.productModel?.categories?.indexOf(e) !=
                                                    (logic.productModel?.categories?.length ?? 0) -
                                                        1)
                                                  Container(
                                                      height: 1,
                                                      color: primaryColor,
                                                      width: double.infinity)
                                              ],
                                            ))
                                        .toList() ??
                                    [],
                              ),
                            ),
                          ),
                        ],
                      )*/
                    ],
                  ),
                  /*const SizedBox(height: 5,),
              SizedBox(
                height: (logic.productModel?.categories?.length ?? 0) == 0 ? 0 : 30.h,
                child: Row(
                  children: [

                    Expanded(
                      child: ListView.builder(
                          itemCount: logic.productModel?.categories?.length ?? 0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.toNamed("/category-details/${logic.productModel?.categories?[index].id}"),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.sp),
                                            color: Colors.grey.shade400),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: CustomText(
                                          logic.productModel?.categories?[index].name,
                                          fontSize: 10,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              )),
                    ),
                  ],
                ),
              ),*/
                ],
              );
            });
  }

  int categoriesNum = 0;

  double calculateRemCategories(List<CategoryModel> categories) {
    double width = 0;
    categoriesNum = 0;
    categories.forEach((element) {
      width += 20;
      var length = element.name?.length ?? 0;
      width += (length * 3.5);
      if (width > 200) {
        categoriesNum++;
        return;
      }
    });
    categoriesNum = (logic.productModel?.categories?.length ?? 0) > 3
        ? (logic.productModel?.categories?.length ?? 0) - 3
        : 0;
    return width;
  }
}
