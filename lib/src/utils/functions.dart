import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/modules/delivery_option/view.dart';
import 'package:entaj/src/modules/faq/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../modules/page_details/view.dart';
import '../modules/search/view.dart';
import '/main.dart';
import '/src/entities/product_details_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_widget/custom_text.dart';

double checkDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return 0.0;
  if (value is List<int>) return value.isEmpty ? 0.0 : value.first.toDouble();
  if (value is List<double>) return value.isEmpty ? 0.0 : value.first;
  return 0.0;
}

String? getLabelInString(dynamic value) {
  if (value is String) return value;
  if (value is Label) return isArabicLanguage ? value.ar : value.en;
  return null;
}

goToLink(String? link) async {
  log(link.toString());
  if (link == null || link == '') return;
  if (link.contains('/faqs')) {
    Get.to(const FaqPage());
    return;
  }
  if (link.contains('/shipping-and-payment')) {
    Get.to(DeliveryOptionPage());
    return;
  }
  if (link.contains('/blogs/') || link.contains('/pages/')) {
    Get.to(PageDetailsPage(
      type: 5,
      title: null,
      url: link,
    ));
    return;
  }
  if (link.contains('search')) {
    int indexOfSearch = link.indexOf('search');
    var searchQ = link.substring(indexOfSearch + 7);
    Get.to(SearchPage(searchQ: Uri.decodeFull(searchQ)));
    return;
  }
  if (link.contains('categories')) {
    try {
      var categoryId =
          link.substring(link.indexOf('categories') + 11, link.indexOf('categories') + 17);
      log(categoryId.toString());
      Get.toNamed("/category-details/$categoryId");
      return;
    } catch (e) {
      try {
        Get.find<MainLogic>().changeSelectedValue(1, true, backCount: 0);
      } catch (e) {}
      return;
    }
  } else if (link.contains('products')) {
    try {
      var productId = link.substring(link.indexOf('products') + 9, link.length);
      var url = Uri.encodeComponent(productId);
      Get.toNamed("/product-details/$url", arguments: {'backCount': '1'});
      return;
    } catch (e) {
      return;
    }
  }
  if (Platform.isAndroid) {
    if (await canLaunch(link)) {
      await launch(link);
    }
  } else {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    }
  }
}

Future<bool> checkInternet() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
    return false;
  }
  return true;
}

String calculateDiscount({required double salePriceTotal, required double priceTotal}) {
  return /*'خصم '.tr +*/
      '${((1 - (salePriceTotal / priceTotal)) * 100).ceil().toString()}%-';
}

String replaceArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(arabic[i], english[i]);
  }
  return input;
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

int getMaxLength(String selectedCode) {
  var num = 9;
  if (selectedCode.contains('966')) num = 9;
  if (selectedCode.contains('971')) num = 9;
  if (selectedCode.contains('965')) num = 8;
  if (selectedCode.contains('968')) num = 8;
  if (selectedCode.contains('973')) num = 8;
  if (selectedCode.contains('974')) num = 8;

  return num;
}

showMessage(String? text, int type) {
  if ((text?.length ?? 0) == 0) return;
  Get.snackbar(
    '',
    "",
    titleText: const SizedBox(),
    messageText: Row(
      children: [
        Expanded(
            child: CustomText(
          text,
          fontSize: 12,
          color: type == 1 ? Colors.white : Colors.black,
        )),
        Icon(
          type == 1 ? Icons.check_circle : Icons.error,
          color: type == 1 ? Colors.white : Colors.black,
        )
      ],
    ),
    snackStyle: SnackStyle.GROUNDED,
    margin: EdgeInsets.zero,
    backgroundColor: type == 1 ? Colors.green : Colors.yellow.shade700,
  );
}
