import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/main.dart';
import '/src/entities/product_details_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  if (link == null || link =='') return;
  if (link.contains('categories')) {
    try {
      var categoryId = link.substring(
          link.indexOf('categories') + 11, link.indexOf('categories') + 17);
      log(categoryId.toString());
      Get.toNamed("/category-details/$categoryId");
      return;
    } catch (e) {
      return;
    }
  } else if (link.contains('products')) {
    try {
      var productId = link.substring(link.indexOf('products') + 9, link.length);
      var url = Uri.encodeComponent(productId);
      Get.toNamed("/product-details/$url", arguments: {'backCount' : '1'});
      return;
    } catch (e) {
      return;
    }
  }
  var url = Uri.parse(link).toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    log("can't launch $url");
    if (link.contains('categories')) {
      try {
        var categoryId = link.substring(
            link.indexOf('categories') + 11, link.indexOf('categories') + 17);
        log(categoryId.toString());
        Get.toNamed("/category-details/$categoryId");
      } catch (e) {}
    } else if (link.contains('products')) {
      try {
        String productId = link.substring(10, link.length);
        var url = Uri.encodeComponent(productId);
        Get.toNamed("/product-details/$url", arguments: {'backCount' : '1'});
      } catch (e) {}
    }
  }
}

Future<bool> checkInternet() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    Fluttertoast.showToast(
        msg: 'يرجى التأكد من اتصالك بالإنترنت'.tr,
        toastLength: Toast.LENGTH_SHORT);
    return false;
  }
  return true;
}

String calculateDiscount(
    {required double salePriceTotal, required double priceTotal}) {
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

int getMaxLength(String selectedCode){
  var num = 9;
  if(selectedCode.contains('966')) num = 9;
  if(selectedCode.contains('971')) num = 9;
  if(selectedCode.contains('965')) num = 8;
  if(selectedCode.contains('968')) num = 8;
  if(selectedCode.contains('973')) num = 8;
  if(selectedCode.contains('974')) num = 8;

  return num;
}

showMessage(String? text ,int type){
  Get.snackbar('', "",
      titleText: const SizedBox(),
      messageText: Row(
        children: [
          Expanded(
              child: CustomText(
                text,
                fontSize: 12,
                color:type == 1 ? Colors.white : Colors.black,
              )),
          Icon(
            type == 1 ? Icons.check_circle :Icons.error,
            color: type == 1 ? Colors.white : Colors.black,
          )
        ],
      ),
      snackStyle: SnackStyle.GROUNDED,
      margin: EdgeInsets.zero,
      backgroundColor: type == 1 ? Colors.green : Colors.yellow.shade700,
      );
}