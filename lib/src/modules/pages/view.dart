import 'dart:developer';

import 'package:entaj/src/modules/faq/view.dart';

import '../../app_config.dart';

import '../../.env.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/functions.dart';
import '../_main/logic.dart';
import '../delivery_option/view.dart';
import '../page_details/view.dart';
import '../../utils/custom_widget/custom_list_tile.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PagesPage extends StatelessWidget {
  final PagesLogic logic = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          "الصفحات الإضافية".tr,
          fontSize: 16,
        ),
      ),
      body: GetBuilder<MainLogic>(
          id: "pages",
          builder: (logic) {
            return logic.isPagesLoading
                ? const CustomProgressIndicator()
                : AppConfig.isSoreUseNewTheme
                    ? RefreshIndicator(
                        onRefresh: () => logic.getHomeScreen(themeId: AppConfig.currentThemeId),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (logic.footerSettings?.links1Title != null &&
                                    logic.footerSettings?.links1Title != '' &&
                                    logic.footerSettings?.links1Hide != true)
                                  CustomText(
                                    logic.footerSettings?.links1Title,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 2,
                                    fontSize: 20,
                                  ),
                                if (logic.footerSettings?.links1Hide != true)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: logic.footerSettings?.links1Links?.length ?? 0,
                                    itemBuilder: (context, index) => CustomListTile(
                                      logic.footerSettings?.links1Links?[index].title,
                                      () => onTap(
                                          logic.footerSettings?.links1Links?[index].url ?? '',
                                          logic.footerSettings?.links1Links?[index].title),
                                      null,
                                    ),
                                  ),
                                if (logic.footerSettings?.links2Title != null &&
                                    logic.footerSettings?.links2Title != '' &&
                                    logic.footerSettings?.links2Hide != true)
                                  const SizedBox(
                                  height: 20,
                                ),
                                if (logic.footerSettings?.links2Title != null &&
                                    logic.footerSettings?.links2Title != '' &&
                                    logic.footerSettings?.links2Hide != true)
                                  CustomText(
                                    logic.footerSettings?.links2Title,
                                    fontSize: 20,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                if (logic.footerSettings?.links2Hide != true)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: logic.footerSettings?.links2Links?.length ?? 0,
                                    itemBuilder: (context, index) => CustomListTile(
                                      logic.footerSettings?.links2Links?[index].title,
                                      () => onTap(
                                          logic.footerSettings?.links2Links?[index].url ?? '',
                                          logic.footerSettings?.links2Links?[index].title),
                                      null,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => logic.getPages(true),
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount: logic.pagesList.length,
                              itemBuilder: (context, index) => CustomListTile(
                                logic.pagesList[index].title,
                                () => Get.to(PageDetailsPage(
                                    pageModel: logic.pagesList[index],
                                    title: logic.pagesList[index].title,
                                    type: 4)),
                                null,
                              ),
                            ))
                          ],
                        ),
                      );
          }),
    );
  }

  onTap(String url, String? title) {
    log(url);
    if (url.contains('categories')) {
      try {
        var categoryId =
            url.substring(url.indexOf('categories') + 11, url.indexOf('categories') + 17);
        Get.toNamed("/category-details/$categoryId");
        return;
      } catch (e) {
        return;
      }
    } else if (url.contains('products')) {
      try {
        var productId = url.substring(url.indexOf('products') + 9, url.length);
        var url1 = Uri.encodeComponent(productId);
        Get.toNamed("/product-details/$url1", arguments: {'backCount': '3'});
        return;
      } catch (e) {
        return;
      }
    } else if (url.contains('shipping-and-payment')) {
      Get.to(DeliveryOptionPage());
    } else if (url.contains('https://') || url.contains('http://')) {
      goToLink(url);
    } else if (url.contains('/faqs')) {
      Get.to(const FaqPage());
    } else {
      Get.to(PageDetailsPage(type: 5, title: title, url: url));
    }
  }
}
