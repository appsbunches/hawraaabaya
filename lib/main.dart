import 'dart:developer';

import 'package:entaj/src/utils/functions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'src/.env.dart';

//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app_config.dart';
import 'src/binding.dart';
import 'src/colors.dart';
import 'src/data/hive/wishlist/wishlist_model.dart';
import 'src/data/shared_preferences/pref_manger.dart';
import 'src/localization/translations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'src/modules/category_details/view.dart';
import 'src/modules/product_details/view.dart';
import 'src/splash/view.dart';
import 'src/utils/dismiss_keyboard.dart';

bool isArabicLanguage = true;
late FirebaseRemoteConfig remoteConfig;
String? notificationUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('general_box');

  remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 1),
  ));
  await remoteConfig.ensureInitialized();
  try {
    await remoteConfig.fetchAndActivate();
    AppConfig.showWhatsAppIconInProductPage = remoteConfig.getString(WA_PRODUCT_KEY).isNotEmpty;
    AppConfig.showWhatsApp = remoteConfig.getBool(WA_ACCOUNT_ENABLE_KEY);
  } catch (e) {}

  if (AppConfig.isEnglishLanguageEnable) {
    isArabicLanguage = await PrefManger().getIsArabic();
  }
  if (AppConfig.isEnableWishlist) {
    Hive.registerAdapter(WishlistModelAdapter());
    await Hive.openBox<WishlistModel>('wishlist_box');
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Binding().dependencies();

  OneSignal.shared.setAppId(OneSignalAppId);

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);

  runApp(const MyApp());
}

void _handleNotificationOpened(OSNotificationOpenedResult result) {
  var additionalData = result.notification.additionalData;
  if (additionalData != null) {
    if (additionalData.containsKey("url")) {
      notificationUrl = result.notification.additionalData?['url'];
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(375, 812),
        builder: (context,child) => GetMaterialApp(
          builder: (context, widget) {
            //add this line
            ScreenUtil.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          debugShowCheckedModeBanner: false,
          title: appName,
          locale: Locale(isArabicLanguage ? 'ar' : 'en'),
          fallbackLocale: Locale(isArabicLanguage ? 'ar' : 'en'),
          initialBinding: Binding(),
          translations: Translation(),
          theme: ThemeData(
              fontFamily: AppConfig.fontName,
              //   textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              primarySwatch: mainColor,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
              )),
          getPages: [
            GetPage(name: '/product-details/:productId', page: () => ProductDetailsPage()),
            GetPage(name: '/category-details/:categoryId', page: () => const CategoryDetailsPage()),
          ],
          home: child,
        ),
        child: const SplashPage(),
      ),
    );
  }
}
