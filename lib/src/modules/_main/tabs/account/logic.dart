import 'dart:developer';
import 'dart:io';

import 'package:entaj/src/modules/faq/view.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../data/remote/api_requests.dart';
import '../../../../data/shared_preferences/pref_manger.dart';
import '../../../../entities/user_model.dart';
import '../../../about_us/view.dart';
import '../../../delivery_option/view.dart';
import '../../../edit_account/view.dart';
import '../../logic.dart';
import '../../../page_details/view.dart';
import '../../../pages/view.dart';
import '../../../select_country/view.dart';
import '../../../../utils/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/functions.dart';
import '../../../_auth/login/view.dart';
import '../../../wishlist/view.dart';
import '../orders/view.dart';
import '/main.dart';
import '../../../../.env.dart';

class AccountLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic _mainLogic = Get.find();
  final PrefManger _prefManger = Get.find();
  bool isLogin = false;
  bool isLoading = false;
  bool isPrivacyLoading = false;
  bool isRefundLoading = false;
  bool isLogoutLoading = false;
  UserModel? userModel;

  Future<void> checkLoginState() async {
    isLogin = await _prefManger.getIsLogin();
    update();
    if (isLogin) await getAccountDetails();
  }

  void goToEditAccount() {
    Get.to(EditAccountPage());
  }

  void goToLogin() {
    Get.to(LoginPage())?.then((value) {
      checkLoginState();
    });
  }

  void goOrdersPage() {
    //   Get.to(LoginPage());
    Get.to(OrdersPage());
  }

  void goToAboutUsPage() async {
    if (!await checkInternet()) return;
    Get.to(AboutUsPage());
  }

  void goToPagesPage() {
    Get.to(PagesPage());
  }

  changeLanguage() async {
    var lang = await _prefManger.getIsArabic();
    await _prefManger.setIsArabic(!lang);
    isArabicLanguage = !lang;
    Get.updateLocale(Locale(isArabicLanguage ? 'ar' : 'en'));
    await _apiRequests.onInit();
    // _mainLogic.getHomeScreen();
    _mainLogic.getStoreSetting();
    _mainLogic.getCategories();
    _mainLogic.getPages(false);
    update();
  }

  getAccountDetails() async {
    isLoading = true;
    update(['account']);
    try {
      var response = await _apiRequests.getAccountDetails();
      log(response.data.toString());
      userModel = UserModel.fromJson(response.data['payload']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['account']);
    update();
  }

  logout() async {
    await _prefManger.setIsLogin(false);
    await _prefManger.setToken(null);
    await _prefManger.setSession(null);
    await _apiRequests.onInit();
    ErrorHandler.generateSession(false, renewSession: true);
    isLogin = false;

    userModel = null;
    update();
  }

  void goToWhatsApp() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await remoteConfig.ensureInitialized();
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {}
    String whatsAppUrl = "";
    String whatsAppUrlFromRemote = remoteConfig.getString(WA_ACCOUNT_KEY);
    log('whatsAppUrlFromRemote => ' + whatsAppUrlFromRemote);
    String phoneNumber = _mainLogic.settingModel?.footer?.socialMedia?.items?.phone ?? '';
    String description = "Hello, From App".tr;
    whatsAppUrl = 'https://wa.me/+$phoneNumber?text=${Uri.parse(description)}';
    whatsAppUrl = whatsAppUrl.replaceAll('++', '+');

    var whatsAppUrlString = (whatsAppUrlFromRemote.isEmpty ? whatsAppUrl : whatsAppUrlFromRemote);
    if(Platform.isAndroid){
      if (await canLaunch(whatsAppUrlString)) {
        await launch(whatsAppUrlString);
      }
    }else{
      if (await canLaunchUrl(Uri.parse(whatsAppUrlString))) {
        await launchUrl(Uri.parse(whatsAppUrlString));
      }
    }

  }

  goToTwitter() {
    launchUrl(Uri.parse(
        "https://www.twitter.com/${_mainLogic.settingModel?.footer?.socialMedia?.items?.twitter}"));
  }

  goToLinkedin() {
    launchUrl(Uri.parse(
        "https://www.snapchat.com/add/${_mainLogic.settingModel?.footer?.socialMedia?.items?.snapchat}"));
  }

  goToInstagram() {
    launchUrl(Uri.parse(
        "https://www.instagram.com/${_mainLogic.settingModel?.footer?.socialMedia?.items?.instagram}"));
  }

  goToFacebook() {
    launchUrl(Uri.parse(
        "https://www.facebook.com/${_mainLogic.settingModel?.footer?.socialMedia?.items?.facebook}"));
  }

  goToPhone() {
    launchUrl(Uri.parse(
        "tel:${_mainLogic.settingModel?.footer?.socialMedia?.items?.phone}"));
  }

  goToEmail() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _mainLogic.settingModel?.footer?.socialMedia?.items?.email,
      query: encodeQueryParameters(<String, String>{'subject': 'رسالة من تطبيق $appName'}),
    );

    log(_mainLogic.settingModel?.footer?.socialMedia?.items?.email ?? '');
    launch(emailLaunchUri.toString());
  }

  goToShippingMethod() async {
    Get.to(DeliveryOptionPage());
  }

  void goToAppBunchesSite() async {
    String urlString = appsBunchesUrl;
    if (await canLaunch(urlString)) launch(urlString);
  }

  goToPrivacyPolicy() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 1,
      title: "سياسة الخصوصية والاستخدام".tr,
      pageModel: _mainLogic.pageModelPrivacy,
    ));
  }

  goToSuggestions() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 6,
      title: "الشكاوى والاقتراحات".tr,
      pageModel: _mainLogic.pageModelSuggestions,
    ));
  }

  getRefundPolicy() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 2,
      title: "سياسة الإستبدال والاسترجاع".tr,
      pageModel: _mainLogic.pageModelRefund,
    ));
  }

  shareApp() {
    Share.share(shareLink);
  }

  goToTermsAndConditions() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 3,
      title: "الشروط والأحكام".tr,
      pageModel: _mainLogic.pageModelTerms,
    ));
  }

  goToCountries() {
    Get.to(SelectCountryPage());
  }

  goToFaq() async {
    if (!await checkInternet()) return;
    Get.to(const FaqPage());
  }

  goToLicense() async {
    if (!await checkInternet()) return;
    Get.to(PageDetailsPage(
      type: 7,
      title: "التراخيص".tr,
      pageModel: _mainLogic.pageModelLicense,
    ));
  }
}