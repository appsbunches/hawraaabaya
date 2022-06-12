import 'dart:developer';

import '../../data/remote/api_requests.dart';
import '../../entities/shipping_method_model.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:get/get.dart';

class DeliveryOptionLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  bool loading = false;
  List<ShippingMethodModel> listShippingMethods = [];
  List list = ['الخيار 1', 'الخيار 2', 'الخيار 3'];
  String? selected;

  @override
  void onInit() {
    super.onInit();
    getShippingMethods(false);
  }

  void setSelected(dynamic value) {
    selected = value;
    update();
  }

  void getShippingMethods(bool forceLoading) async {
    if(listShippingMethods.isNotEmpty && !forceLoading){
      return;
    }
    loading = true;
    update();
    try {
      var response = await _apiRequests.getShippingMethods();
      listShippingMethods = (response.data['payload']['store_shipping_methods'] as List)
          .map((e) => ShippingMethodModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    loading = false;
    update();
  }

  String getSelectedCities(List<City> selectCities) {
    var cities = '';
    int count = 0;

    if (selectCities.length > 2) {
      for (int i = 0; i < 3; i++) {
        (count == 0)
            ? cities =
                cities + (selectCities[i].name ?? '')
            : cities = cities +
                " , " +
            (selectCities[i].name ?? '');
        count += 1;
      }

      return cities + " , " + " مدن".tr + "${selectCities.length - 3}";
    } else {
      for (var element in selectCities) {
        (count == 0)
            ? cities = cities + (element.name ?? '')
            : cities = cities + " , " + (element.name ?? '');
        count += 1;
      }
      return cities;
    }
  }
}
