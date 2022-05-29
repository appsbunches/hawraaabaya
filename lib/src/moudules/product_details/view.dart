import 'package:entaj/src/moudules/_main/widgets/my_bottom_nav.dart';

import '../../app_config.dart';
import '../../binding.dart';
import '../../colors.dart';
import '../../entities/product_details_model.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../_main/view.dart';
import 'widgets/product_add_to_cart_widget.dart';
import 'widgets/product_custom_field.dart';
import 'widgets/product_image_widget.dart';
import 'widgets/product_notify_widget.dart';
import 'widgets/product_offer_widget.dart';
import 'widgets/product_price.dart';
import 'widgets/product_related_widget.dart';
import '../../services/app_events.dart';
import 'widgets/product_categories_list.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/item_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../main.dart';
import 'logic.dart';
import 'widgets/product_description_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ProductDetailsLogic logic = Get.put(ProductDetailsLogic());

  final AppEvents _appEvents = Get.find();

  late FocusNode phoneNumberFocusNode;

  @override
  void initState() {
    phoneNumberFocusNode = FocusNode();
    phoneNumberFocusNode.addListener(() {
      logic.update(['Whats']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productId = Get.parameters['productId'] ?? 'unknown';
    int backCount = int.parse(Get.arguments['backCount'] ?? '1');
    logic.quantityController.text = '1';
    logic.getProductDetails(productId);
    logic.selectedImageIndex = 0;
    return !AppConfig.enhancementsV1
        ? buildOldScaffold(productId, backCount)
        : Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: backCount == 0 ? null : MyBottomNavigation(backCount: backCount),
      floatingActionButton: GetBuilder<ProductDetailsLogic>(
          init: Get.find<ProductDetailsLogic>(),
          id: productId,
          builder: (context) {
            return !AppConfig.showWhatsAppIconInProductPage || logic.isLoading
                ? const SizedBox()
                : GetBuilder<ProductDetailsLogic>(
                init: Get.find<ProductDetailsLogic>(),
                id: 'Whats',
                builder: (logic) {
                  return Container(
                    decoration: BoxDecoration(
                        color: primaryColor, borderRadius: BorderRadius.circular(70.sp)),
                    margin: EdgeInsetsDirectional.only(
                        bottom: phoneNumberFocusNode.hasFocus ? 110.h : 80.h),
                    height: 50.sp,
                    width: 50.sp,
                    child: IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      icon: Image.asset(
                        iconWhatsapp,
                        scale: 2,
                      ),
                      onPressed: () => logic.goToWhatsApp(
                          message:
                          'احتاج معلومات اكثر عن المنتج ${logic.productModel?.htmlUrl}'),
                    ),
                  );
                });
          }),
      appBar: AppBar(
        actions: [
          /*
          IconButton(
              onPressed: () {
                Get.offAll(const MainPage(), binding: Binding());
              },
              icon: GetBuilder<ProductDetailsLogic>(
                  id: productId,
                  builder: (logic) {
                    return logic.productModel == null
                        ? const SizedBox()
                        : Image.asset(
                            iconHome,
                            color: primaryColor,
                            scale: 2,
                          );
                  })),*/
          GetBuilder<ProductDetailsLogic>(
              id: productId,
              builder: (logic) {
                return logic.productModel == null
                    ? const SizedBox()
                    : InkWell(
                  onTap: () => Share.share(logic.productModel?.htmlUrl ?? ''),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //CustomText("مشاركة".tr),
                        //const SizedBox(width: 5,),
                        const Icon(Icons.share)
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
      body: GetBuilder<ProductDetailsLogic>(
        // assignId: false,
          id: productId,
          builder: (logic) {
            return logic.isLoading
                ? const CustomProgressIndicator()
                : !logic.hasInternet
                ? Container(
              width: double.infinity,
              height: 600.h,
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.grey,
                    size: 60,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    'يرجى التأكد من اتصالك بالإنترنت'.tr,
                    color: Colors.grey,
                  )
                ],
              ),
            )
                : (logic.productModel == null && logic.isProductDeleted)
                ? Center(child: CustomText("Product has been deleted".tr))
                : logic.productModel == null
                ? const SizedBox()
                : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        logic.getProductDetails(productId),
                    child: SingleChildScrollView(
                      child: GetBuilder<ProductDetailsLogic>(
                          id: productId,
                          builder: (logic) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductImageWidget(productId: productId),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                        logic.productModel?.name,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      if (logic.productModel?.offerLabel !=
                                          null &&
                                          AppConfig.enhancementsV1)
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      if (logic.productModel?.offerLabel !=
                                          null &&
                                          AppConfig.enhancementsV1)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.wallet_giftcard,
                                              color: moveColor,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                logic.productModel
                                                    ?.offerLabel,
                                                color: Colors.black,
                                                textAlign: TextAlign.start,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (AppConfig.enhancementsV1)
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      if (logic.productModel?.rating
                                          ?.average !=
                                          0.0)
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              itemBuilder:
                                                  (context, index) =>
                                              const Icon(
                                                Icons.star,
                                                color: yalowColor,
                                              ),
                                              itemSize: 20,
                                              rating: logic.productModel
                                                  ?.rating?.average ??
                                                  0.0,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              '(${logic.productModel?.rating?.totalCount})',
                                              color: Colors.grey.shade800,
                                              fontSize: 11,
                                            )
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const ProductDescriptionWidget(),
                                      /* CustomText(
                                                                "رمز المنتج: ".tr +
                                                                    logic.productModel!.sku
                                                                        .toString(),
                                                                fontSize: 10,
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              ProductCategoriesList(),*/
                                    ],
                                  ),
                                ),
                                /* const SizedBox(
                                                          height: 20,
                                                        ),*/
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      if (logic.productModel?.options
                                          ?.isNotEmpty ==
                                          true)
                                        GridView.builder(
                                          itemCount: logic.productModel
                                              ?.options?.length ??
                                              0,
                                          shrinkWrap: true,
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext
                                          context,
                                              int index) =>
                                              ItemOption(
                                                  logic
                                                      .productModel
                                                      ?.options?[index]
                                                      .choices,
                                                  logic.productModel
                                                      ?.options?[index]),
                                          gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1.7,
                                              crossAxisSpacing: 15),
                                        ),
                                    ],
                                  ),
                                ),
                                buildCustomUserInputField(
                                    logic.productModel!),
                                ProductOfferWidget(
                                  productId: productId,
                                ),

                                Center(
                                  child: InkWell(
                                    onTap: () => logic.goToReviews(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            "عرض جميع التقييمات".tr,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  (isArabicLanguage
                                                      ? 180
                                                      : 0) /
                                                      360),
                                              child: Image.asset(
                                                iconBack,
                                                scale: 2,
                                                color: secondaryColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ProductRelatedWidget(
                                  productId: productId,
                                  backCount: backCount,
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const ProductNotifyWidget(),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 10,
                                spreadRadius: 0.1)
                          ],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25.sp),
                              topLeft: Radius.circular(25.sp)),
                          color: logic.productModel?.quantity == 0
                              ? Colors.grey.shade100
                              : Colors.white),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15.h),
                      child: logic.productModel?.quantity == 0
                          ? buildIsEmpty()
                          : ProductAddToCartWidget(
                          productId, phoneNumberFocusNode, _appEvents),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  GetBuilder<ProductDetailsLogic> buildIsEmpty() {
    return GetBuilder<ProductDetailsLogic>(
        id: "isEmpty",
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomText(
                  "المنتج غير متوفر حالياً".tr,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45.h,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15.sp)),
                        child: TextField(
                          controller: logic.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: const TextStyle(fontSize: 12),
                              hintText:
                              "أدخل بريدك الإلكتروني ليتم إعلامك عندما يتوفر مرة أخرى".tr),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CustomButtonWidget(
                            title: "ارسل",
                            radius: 10,
                            color: !logic.isEmpty ? primaryColor : Colors.grey.shade300,
                            textColor: !logic.isEmpty ? Colors.white : Colors.grey,
                            //textColor: Colors.grey,
                            loading: logic.isNotifyMeLoading,
                            onClick: logic.isEmpty ? null : () => logic.sentNotification()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Scaffold buildOldScaffold(String productId, int backCount) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(const MainPage(), binding: Binding());
              },
              icon: GetBuilder<ProductDetailsLogic>(
                  id: productId,
                  builder: (logic) {
                    return logic.productModel == null
                        ? const SizedBox()
                        : Image.asset(
                      iconHome,
                      color: primaryColor,
                      scale: 2,
                    );
                  })),
          GetBuilder<ProductDetailsLogic>(
              id: productId,
              builder: (logic) {
                return logic.productModel == null
                    ? const SizedBox()
                    : InkWell(
                  onTap: () => Share.share(logic.productModel?.htmlUrl ?? ''),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText("مشاركة".tr),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.share)
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
      body: GetBuilder<ProductDetailsLogic>(
        // assignId: false,
          id: productId,
          builder: (logic) {
            return logic.isLoading
                ? const CustomProgressIndicator()
                : !logic.hasInternet
                ? Container(
              width: double.infinity,
              height: 600.h,
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.grey,
                    size: 60,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    'يرجى التأكد من اتصالك بالإنترنت'.tr,
                    color: Colors.grey,
                  )
                ],
              ),
            )
                : (logic.productModel == null && logic.isProductDeleted)
                ? Center(child: CustomText("Product has been deleted".tr))
                : logic.productModel == null
                ? const SizedBox()
                : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => logic.getProductDetails(productId),
                    child: SingleChildScrollView(
                      child: GetBuilder<ProductDetailsLogic>(
                          id: productId,
                          builder: (logic) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductImageWidget(productId: productId),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        logic.productModel?.name,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      if (logic.productModel?.offerLabel !=
                                          null &&
                                          AppConfig.enhancementsV1)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.wallet_giftcard,
                                              color: moveColor,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                logic.productModel?.offerLabel,
                                                color: Colors.black,
                                                textAlign: TextAlign.start,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (AppConfig.enhancementsV1)
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ProductCategoriesList(),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            itemBuilder: (context, index) =>
                                            const Icon(
                                              Icons.star,
                                              color: yalowColor,
                                            ),
                                            itemSize: 20,
                                            rating: logic.productModel?.rating
                                                ?.average ??
                                                0.0,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            '(${logic.productModel?.rating?.totalCount})',
                                            color: Colors.grey.shade800,
                                            fontSize: 11,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomText(
                                        "رمز المنتج: ".tr +
                                            logic.productModel!.sku.toString(),
                                        fontSize: 10,
                                      ),
                                      const ProductDescriptionWidget()
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ProductOfferWidget(
                                  productId: productId,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(
                                  thickness: 3,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (logic.productModel?.options?.length !=
                                          0)
                                        GridView.builder(
                                          itemCount: logic.productModel?.options
                                              ?.length ??
                                              0,
                                          shrinkWrap: true,
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, int index) =>
                                              ItemOption(
                                                  logic
                                                      .productModel
                                                      ?.options?[index]
                                                      .choices,
                                                  logic.productModel
                                                      ?.options?[index]),
                                          gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1.7,
                                              crossAxisSpacing: 15),
                                        ),
                                    ],
                                  ),
                                ),
                                const ProductPrice(),
                                buildCustomUserInputField(logic.productModel!),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(
                                  thickness: 3,
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () => logic.goToReviews(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            "عرض جميع التقييمات".tr,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          RotationTransition(
                                              turns: AlwaysStoppedAnimation(
                                                  (isArabicLanguage ? 180 : 0) /
                                                      360),
                                              child: Image.asset(
                                                iconBack,
                                                scale: 2,
                                                color: secondaryColor,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ProductRelatedWidget(
                                  productId: productId,
                                  backCount: backCount,
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const ProductNotifyWidget(),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 10,
                                spreadRadius: 0.1)
                          ],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25.sp),
                              topLeft: Radius.circular(25.sp)),
                          color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: logic.productModel?.quantity == 0
                          ? GetBuilder<ProductDetailsLogic>(
                          id: "isEmpty",
                          builder: (logic) {
                            return CustomButtonWidget(
                                title: "ارسل".tr,
                                color: !logic.isEmpty
                                    ? primaryColor
                                    : Colors.grey.shade300,
                                textColor: !logic.isEmpty
                                    ? Colors.white
                                    : Colors.grey,
                                //textColor: Colors.grey,
                                loading: logic.isNotifyMeLoading,
                                onClick: logic.isEmpty
                                    ? null
                                    : () => logic.sentNotification());
                          })
                          : ProductAddToCartWidget(
                          productId, phoneNumberFocusNode, _appEvents),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Widget buildCustomUserInputField(ProductDetailsModel productDetailsModel) {
    if (productDetailsModel.customFields?.isNotEmpty == true) {
      return ListView.builder(
          itemCount: productDetailsModel.customFields?.length ?? 0,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCustomField(customField: productDetailsModel.customFields![index]);
          });
    } else {
      return const SizedBox();
    }
  }
}
