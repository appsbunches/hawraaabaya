import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:entaj/src/utils/functions.dart';
import '../../../main.dart';
import '../../data/remote/api_requests.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../modules/_main/tabs/cart/logic.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static Future<bool> handleError(
      Object e, {
        bool? showToast,
      }) async {
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout) {
        final ConnectivityResult result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.none) {
          showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
          return false;
        }
        return false;
      }
      if (e.response != null && showToast == null) {
        try {
          if (e.response!.data['message']['description']
              .toString()
              .contains('Error in cart session') ||
              e.response!.data['message']['description'].toString().contains('خطأ في سلة الشراء')) {
            await generateSession(false);
          } else if (e.response!.data['message']['code'] == 'ERROR_CART_IS_RESERVED') {
            Get.snackbar(
              '',
              "",
              duration: const Duration(seconds: 5),
              titleText: const SizedBox(),
              messageText: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: CustomText(
                        e.response!.data['message']['name'].toString().replaceAll('/n', '') +
                            '، ' +
                            e.response!.data['message']['description'],
                        fontSize: 12,
                        color: Colors.black,
                      )),
                  InkWell(
                    onTap: () {
                      Get.back();
                      generateSession(true);
                    },
                    child: CustomText(
                      'إلغاء السلة'.tr,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
              snackStyle: SnackStyle.GROUNDED,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              backgroundColor: Colors.yellow.shade700,
            );
          } else if (e.response!.data['message']['description'] == 'Unauthenticated') {
            //refreshToken();
          } else {
            showMessage(e.response!.data['message']['description'].toString(), 2);
          }
        } catch (ee) {
          log("ErrorHandler catch ==>  " + ee.toString());
          showMessage(e.response!.data.toString(), 2);
        }
        log("ErrorHandler DioError ==> " + e.response!.data.toString());
      } else {
        final ConnectivityResult result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.none) {
          showMessage('يرجى التأكد من اتصالك بالإنترنت'.tr, 2);
          return false;
        }
      }
      return true;
    } else {
      log("ErrorHandler ==> " + e.toString());
      return true;
    }
  }

  static Future<void> generateSession(bool isCancel, {renewSession = false}) async {
    try {
      final ApiRequests _apiRequests = Get.find();
      final PrefManger _prefManger = Get.find();
      final CartLogic _cartLogic = Get.find();
      var response = isCancel ? await _apiRequests.cloneCart() : await _apiRequests.createSession();
      var session = response.data['payload'][isCancel ? 'session_id' : 'cart_session_id'];
      log("new session => $session");
      await _prefManger.setSession(session);
      await _apiRequests.onInit();
      if (isCancel) {
        _cartLogic.getCartItems(true);
      } else {
        _cartLogic.getCartItems(true);
        if (!renewSession) {
          showMessage('حاول مجدداً'.tr, 2);
        }
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
