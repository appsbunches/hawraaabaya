import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/home_screen_model.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/item_widget/item_testimonial.dart';
import '../logic.dart';

class TestimonialWidget extends StatelessWidget {
  final String? title;
  final bool display;
  final List<Items> items;

  const TestimonialWidget(
      {Key? key, required this.title, required this.display, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return logic.isHomeLoading
              ? Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomText(
                          logic.testimonials?.title ?? '',
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200.h,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => const ItemTestimonial()),
                      ),
                    ],
                  ))
              : !display
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: CustomText(
                                  title,
                                  fontSize: 17,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: items
                                        .map((e) => ItemTestimonial(
                                              item: e,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
        });
  }
}
