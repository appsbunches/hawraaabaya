import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/services/app_events.dart';
import 'package:get/get.dart';

import 'data/hive/wishlist/hive_controller.dart';
import 'data/remote/api_requests.dart';
import 'data/shared_preferences/pref_manger.dart';
import 'modules/_main/tabs/home/logic.dart';
import 'modules/delivery_option/logic.dart';
import 'modules/_main/tabs/cart/logic.dart';
import 'modules/pages/logic.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrefManger>(() => PrefManger());
    Get.lazyPut<ApiRequests>(() => ApiRequests());
    Get.lazyPut<AppEvents>(() => AppEvents());
    Get.lazyPut<MainLogic>(() => MainLogic());
    Get.lazyPut<CartLogic>(() => CartLogic() , fenix: true);
    Get.lazyPut<DeliveryOptionLogic>(() => DeliveryOptionLogic());
    Get.lazyPut<PagesLogic>(() => PagesLogic());
    Get.lazyPut<HomeLogic>(() => HomeLogic());
    //  Get.lazyPut<ProductDetailsLogic>(() => ProductDetailsLogic());
  }
}
