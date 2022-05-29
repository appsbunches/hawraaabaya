import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:entaj/src/moudules/_main/logic.dart';
import 'package:entaj/src/utils/functions.dart';
import '../../../../colors.dart';
import '../../../../data/remote/api_requests.dart';
import '../../../../data/shared_preferences/pref_manger.dart';
import '../../../../entities/cart_model.dart';
import '../../../../entities/discount_response_model.dart';
import '../../../../entities/product_details_model.dart';
import '../../../payment/view.dart';
import '../../../../services/app_events.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/error_handler/error_handler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../../../../.env.dart';
import '../../../_auth/login/view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final PrefManger _prefManger = Get.find();
  final AppEvents _appEvents = Get.find();
  final MainLogic _mainLogic = Get.find();
  final TextEditingController couponController = TextEditingController();

  bool hasInternet = true;
  bool isCartLoading = false;
  bool isCartItemLoading = false;
  bool checkoutLoading = false;
  bool isCouponLoading = false;
  bool isRequestToCouponLoading = false;
  bool isLoading = false;
  bool isDiscountLoading = false;
  bool clickOnAddCoupon = false;
  CartModel? cartModel;
  String? couponError;
  DiscountResponseModel? discountResponseModel;
  DiscountResponseModel? mobileDiscountResponseModel;

  @override
  void onInit() {
    super.onInit();
    getCartItems(true);
  }

  Future<bool> checkInternetConnection() async {
    var connection = (await Connectivity().checkConnectivity() != ConnectivityResult.none);
    hasInternet = connection;
    update(['cart']);
    return connection;
  }

  double getShippingFreeTarget() {
    try {
      var target = discountResponseModel!.conditions!.first.value!.first;
      var discount = (target - cartModel!.productsSubtotal).floorToDouble();
      if (discount < 0) {
        return 0;
      }
      return discount;
    } catch (e) {
      return 0.0;
    }
  }

  void clickToAddCoupon() {
    clickOnAddCoupon = true;
    update(['cart']);
  }

  void goToCheckout() {
    generateCheckoutToken();
    // Get.to(SuccessOrderPage());
  }

  Future<void> getCartItems(bool withLoading) async {
    if (!await checkInternetConnection()) return;
    if (withLoading) {
      isLoading = true;
      // update();
    }

    try {
      isCartItemLoading = false;
      var response = await _apiRequests.getCart();
      //log(json.encode(response.data));
      cartModel = CartModel.fromJson(response.data['payload']);

      clickOnAddCoupon = cartModel?.coupon != null;
      couponController.text = cartModel?.coupon?.code ?? '';
      getDiscountRules();
    } catch (e) {
      hasInternet = await ErrorHandler.handleError(e);
    }

    if (withLoading) {
      isLoading = false;
    }
    update(['cart1']);
  }

  Future<void> getDiscountRules() async {
    discountResponseModel = null;
    isDiscountLoading = true;
    update(['cart']);

    try {
      var response = await _apiRequests.getDiscountRules();

      var list = (response.data['payload'] as List);
      list.forEach((element) {
        if (element['code'] == 'free_shipping') {
          discountResponseModel = DiscountResponseModel.fromJson(element);
        }
        if (element['code'] == 'mobile_app') {
          mobileDiscountResponseModel = DiscountResponseModel.fromJson(element);
        }
      });
    } catch (e) {
      await ErrorHandler.handleError(e);
    }

    isDiscountLoading = false;
    update(['cart']);
  }

  Future<void> deleteItem(int? id) async {
    if (id == null) return;
    if (isCartItemLoading) return;
    isCartItemLoading = true;

    try {
      var response = await _apiRequests.deleteCartItem(id);
      cartModel?.products?.removeWhere((element) => element.id == id);
      getCartItems(false);
    } catch (e) {
      //ErrorHandler.handleError(e);
    }
    isCartItemLoading = false;
  }

  Future<void> deleteItemFromProductDetailsPage(int? id, String? productId) async {
    if (id == null) return;

    try {
      var response = await _apiRequests.deleteCartItem(id);
      cartModel?.products?.removeWhere((element) => element.id == id);
      getCartItems(false);
    } catch (e) {
      //ErrorHandler.handleError(e);
    }

    update(['addToCart$productId']);
  }

  void redeemCoupon() async {
    couponError = null;
    if (couponController.text.isEmpty) {
      Fluttertoast.showToast(msg: "يرجى ادخال رمز الكوبون".tr);
      return;
    }
    isCouponLoading = true;
    update(['cart']);

    try {
      var response = await _apiRequests.redeemCoupon(couponController.text);
      await getCartItems(false);
    } catch (e) {
      try {
        if (e is DioError) {
          couponError = e.response?.data['message']['description'];
        }
      } catch (e) {
        ErrorHandler.handleError(e);
      }
    }

    isCouponLoading = false;
    isRequestToCouponLoading = true;
    update(['cart']);
  }

  void removeCoupon() async {
    isCouponLoading = true;
    update(['cart']);

    try {
      var response = await _apiRequests.removeCoupon();
      await getCartItems(false);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isCouponLoading = false;
    update(['cart']);
  }

  Future<void> addToCart(String? productId,
      {required bool hasOptions,
      required String quantity,
      required bool hasFields,
      int? index,
      BuildContext? context,
      List? customUserInputFieldRequest}) async {
    if (productId == null) {
      Fluttertoast.showToast(msg: "يرجى اختيار جميع الخيارات".tr, backgroundColor: Colors.orange);
      return;
    }
    if (quantity == null || quantity == '' || quantity == '0') {
      Fluttertoast.showToast(msg: "يرجى ادخال الكمية".tr, backgroundColor: Colors.orange);
      return;
    }
    if (context != null) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    isCartLoading = true;
    update(['addToCart$productId']);

    try {
      var response = await _apiRequests.addCartItem(
          productId: productId,
          quantity: quantity.toString(),
          hasFields: hasFields,
          customFieldsList: customUserInputFieldRequest);
      await getCartItems(false);
      showMessage("تم اضافة المنتج إلى السلة".tr, 1);
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      await ErrorHandler.handleError(e);
    }

    isCartLoading = false;
    update(['addToCart$productId']);
  }

  void updateCartItem(int id, int quantity, {int? index}) async {
    if (isCartItemLoading) return;
    isCartItemLoading = true;
    //   update([id]);

    try {
      var response = await _apiRequests.updateCartItem(id.toString(), quantity.toString());
      await getCartItems(false);
    } catch (e) {
      await getCartItems(false);
      // ErrorHandler.handleError(e);
    }

    isCartItemLoading = false;
//    update([id]);
  }

  clearCoupon() {
    couponController.text = '';
    couponError = null;
    isRequestToCouponLoading = false;
    update(['cart']);
  }

  decreaseQuantity(Products? product, {int? newQty1}) {
    if (product == null) return;
    if (isCartItemLoading) return;
    if (product.quantity == 1) {
      return;
    }

    late int newQty;
    if (newQty1 == null) {
      newQty = product.quantity! - 1;
    } else {
      newQty = newQty1;
    }

    if (product.purchaseRestrictions?.minQuantityPerCart != null) {
      if ((product.purchaseRestrictions!.minQuantityPerCart! - 1) >= newQty) return;
    }
    product.quantity = newQty;
    update([product.id!]);
    startCount(product, newQty);
  }

  increaseQuantity(Products? product, {int? newQty1}) {
    if (product == null) return;
    late int newQty;
    if (newQty1 == null) {
      newQty = product.quantity! + 1;
    } else {
      newQty = newQty1;
    }
    if (product.purchaseRestrictions?.maxQuantityPerCart != null) {
      if ((product.purchaseRestrictions!.maxQuantityPerCart! + 1) <= newQty) return;
    } else {
      if ((product.quantity ?? 0) > 9999) return;
    }
    if (product.originalProductQuantity != null) {
      if ((product.originalProductQuantity! + 1) <= newQty) return;
    }
    if (isCartItemLoading) return;
    product.quantity = newQty;
    update([product.id!]);
    startCount(product, newQty);
  }

  Timer? _timer;

  void startCount(Products product, newQty) async {
    if (_timer != null) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      updateCartItem(product.id!, newQty);
    });
  }

  void generateCheckoutToken() async {
    if (_mainLogic.settingModel?.settings?.availability?.isStoreClosed == true) {
      Fluttertoast.showToast(
          msg: _mainLogic.settingModel?.settings?.availability?.message?.ar ?? '');
      return;
    }
    if (!await _prefManger.getIsLogin()) {
      Get.to(LoginPage())?.then((value) async {
        isLoading = true;
        //   update(['cart1']);
        await Future.delayed(const Duration(seconds: 3));
        getCartItems(true);
      });
      return;
    }

    checkoutLoading = true;
    update(['checkout']);

    try {
      var response = await _apiRequests.verifyCart();
    } catch (e) {
      if (e is DioError) {
        if (e.response.toString().contains('ERROR_CART_IS_RESERVED')) {
          ErrorHandler.handleError(e);

          checkoutLoading = false;
          update(['checkout']);
          return;
        }
      }
    }
    try {
      var response = await _apiRequests.generateCheckoutToken();

      String checkoutToken = response.data['payload']['checkout_token'].toString();
      String checkoutUrl =
          '$storeUrl/checkout/from-token?hide-header-footer=true&checkout-token=$checkoutToken';
      log(checkoutUrl);

      _appEvents.logCheckout(
          coupon: cartModel?.coupon?.code,
          value: cartModel?.productsSubtotal,
          items: cartModel?.products
              ?.map(
                  (e) => AnalyticsEventItem(itemId: e.productId, itemName: e.name, price: e.total))
              .toList());

      Get.to(PaymentScreen(url: checkoutUrl),
              transition: Transition.downToUp, fullscreenDialog: true)
          ?.then((value) async {
        isLoading = true;
        update();
        await Future.delayed(const Duration(seconds: 3));
        await getCartItems(true);
      });
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    checkoutLoading = false;
    update(['checkout']);
  }

  String? getTotal() {
    String? total;
    try {
      total = cartModel?.totals?.firstWhere((element) => element.code == 'total').valueString;
    } catch (e) {}
    return total;
  }

  bool checkIfExist(String? mProductId /*, List<ProductDetailsModel>? variants*/) {
    bool exist = false;
    cartModel?.products?.forEach((elementCart) {
      if (elementCart.productId == mProductId?.replaceAll('-', '')) exist = true;
      /*variants?.forEach((element) {
        if (elementCart.productId == element.id?.replaceAll('-', '')) exist = true;
      });*/
    });

    return exist;
  }

  Products? getCartItem(String? mProductId) {
    Products? product;
    cartModel?.products?.forEach((element) {
      if (element.productId == mProductId?.replaceAll('-', '')) product = element;
    });

    return product;
  }
}
