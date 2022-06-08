import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../colors.dart';
import '../../images.dart';
import 'logic.dart';

class DeliveryOptionPage extends StatelessWidget {
  final DeliveryOptionLogic logic = Get.find();

  DeliveryOptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.getShippingMethods(false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          "خيارات الشحن".tr,
          fontSize: 16,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: GetBuilder<DeliveryOptionLogic>(builder: (logic) {
          return RefreshIndicator(
            onRefresh: () async => logic.getShippingMethods(true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: logic.loading
                        ? const CustomProgressIndicator()
                        : ListView.builder(
                            itemCount: logic.listShippingMethods.length,
                            itemBuilder: (BuildContext context, int index) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            iconCarDelivery,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "خيارات الشحن".tr,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor,
                                                fontSize: 10,
                                              ),
                                              CustomText(
                                                logic.listShippingMethods[index].name,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            iconCities,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  "المدن التي يتم تغطيتها".tr,
                                                  fontWeight: FontWeight.bold,
                                                  color: secondaryColor,
                                                  fontSize: 10,
                                                ),
                                                CustomText(
                                                  logic.getSelectedCities(logic
                                                          .listShippingMethods[index]
                                                          .selectCities ??
                                                      []),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            iconCoins,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "تكلفة الشحن".tr,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor,
                                                fontSize: 10,
                                              ),
                                              CustomText(
                                                logic.listShippingMethods[index]
                                                    .costString,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if(logic.listShippingMethods[index].insidePickupCitiesCostString !=null)
                                      Row(
                                        children: [
                                          Image.asset(
                                            iconCoins,
                                            scale: 2,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "تكلفة الشحن داخل مدينة التاجر".tr,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor,
                                                fontSize: 10,
                                              ),
                                              CustomText(
                                                logic.listShippingMethods[index]
                                                    .insidePickupCitiesCostString,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if(logic.listShippingMethods[index].outsidePickupCitiesCostString !=null)
                                        Row(
                                        children: [
                                          Image.asset(
                                            iconCoins,
                                            color: Colors.white,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "تكلفة الشحن خارج مدينة التاجر".tr,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor,
                                                fontSize: 10,
                                              ),
                                              CustomText(
                                                logic.listShippingMethods[index]
                                                    .outsidePickupCitiesCostString,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (logic.listShippingMethods[index].codEnabled == true ||
                                          logic.listShippingMethods[index].codAvailable == true)
                                        Row(
                                          children: [
                                            Image.asset(
                                              iconCoins,
                                              color: Colors.white,
                                              scale: 2,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  "الدفع عند الاستلام".tr,
                                                  fontWeight: FontWeight.bold,
                                                  color: secondaryColor,
                                                  fontSize: 10,
                                                ),
                                                CustomText(
                                                  logic.listShippingMethods[index].codFeeString,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 3,
                                  color: Colors.grey.shade200,
                                )
                              ],
                            ),
                          ))
              ],
            ),
          );
        }),
      ),
    );
  }
}
