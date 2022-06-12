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
                Expanded(
                    child: logic.loading
                        ? const CustomProgressIndicator()
                        : ListView.builder(
                            itemCount: logic.listShippingMethods.length,
                            padding: const EdgeInsets.only(top: 20),
                            itemBuilder: (BuildContext context, int index) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              iconCoins,
                                              scale: 2,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            CustomText(
                                              "تكلفة الشحن".tr,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      GridView.builder(
                                        itemCount:
                                            logic.listShippingMethods[index].cost?.length ?? 0,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index1) {
                                          var item = logic.listShippingMethods[index].cost?[index1];
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                item?.title ?? "تكلفة الشحن".tr,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor,
                                                fontSize: 10,
                                              ),
                                              CustomText(
                                                item?.costString,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          );
                                        },
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2 ,childAspectRatio: 2.4),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              iconCoins,
                                              scale: 2,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            CustomText(
                                              "الدفع عند الاستلام".tr,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (logic.listShippingMethods[index].codEnabled == true &&
                                          logic.listShippingMethods[index].codFee?.isNotEmpty ==
                                              true)
                                        GridView.builder(
                                            itemCount:
                                                logic.listShippingMethods[index].codFee?.length ??
                                                    0,
                                            shrinkWrap: true,
                                            gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2 ,childAspectRatio: 2.4),
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index1) {
                                              var item =
                                                  logic.listShippingMethods[index].codFee?[index1];
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    item?.title ?? "الدفع عند الاستلام".tr,
                                                    fontWeight: FontWeight.bold,
                                                    color: secondaryColor,
                                                    fontSize: 10,
                                                  ),
                                                  CustomText(
                                                    item?.codFeeString,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ],
                                              );
                                            }),
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
