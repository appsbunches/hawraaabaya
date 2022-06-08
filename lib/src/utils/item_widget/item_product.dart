import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';

import '../../../main.dart';
import '../../data/shared_preferences/pref_manger.dart';
import '../../entities/product_details_model.dart';
import '../../modules/_auth/login/view.dart';
import '../../modules/wishlist/logic.dart';
import '../custom_widget/custom_image.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../data/hive/wishlist/hive_controller.dart';
import '../../data/hive/wishlist/wishlist_model.dart';
import '../../images.dart';
import '../../modules/_main/tabs/cart/logic.dart';
import '../../services/app_events.dart';
import '../functions.dart';

class ItemProduct extends StatefulWidget {
  final ProductDetailsModel? product;
  final int backCount;
  final bool forWishlist;
  final bool horizontal;
  final double width;

  const ItemProduct(this.product,
      {Key? key,
        this.forWishlist = false,
        this.width = 140,
        required this.backCount,
        required this.horizontal})
      : super(key: key);

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  final AppEvents _appEvents = Get.find();

  bool isLoading = false;
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: widget.horizontal ? 10 : 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.sp),
        onTap: () => widget.product == null
            ? () {}
            : Get.toNamed("/product-details/${widget.product!.id!}",
            preventDuplicates: false, arguments: {'backCount': widget.backCount.toString()}),
        child: buildContainer(),
      ),
    );
  }

  Stack buildContainer() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: widget.horizontal ? widget.width.w : null,
            decoration: const BoxDecoration(color: Colors.white),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                widget.product?.quantity == 0 ? Colors.white : Colors.transparent,
                BlendMode.saturation,
              ),
              child: widget.product == null
                  ? const SizedBox(
                height: double.infinity,
              )
                  : Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.sp)),
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  child: CustomImage(
                                    url: widget.product?.images?.length == 0
                                        ? null
                                        : widget.product?.images?[0].image?.small,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            if (widget.product!.offerLabel != null)
                              PositionedDirectional(
                                start: 0,
                                child: Container(
                                  width: widget.product!.offerLabel!.length > 30 ? 150.w : null,
                                  margin: const EdgeInsets.only(top: 10, left: 3, right: 3),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(15.sp)),
                                  child: CustomText(
                                    widget.product?.offerLabel,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    textAlign: TextAlign.center,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomText(
                              widget.product?.name,
                              maxLines: 2,
                              fontSize: 9,
                            ),
                          ),
                          if (widget.product?.formattedSalePrice != null)
                            CustomText(
                              widget.product?.formattedPrice,
                              color: formattedSalePriceTextColor,
                              lineThrough: true,
                              height: 1,
                              fontSize: 9,
                              //fontWeight: FontWeight.w800,
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: CustomText(
                                  widget.product?.formattedSalePrice ??
                                      widget.product?.formattedPrice,
                                  color: widget.product?.formattedSalePrice != null
                                      ? formattedPriceTextColorWithSale
                                      : formattedPriceTextColorWithoutSale,
                                  fontSize: 11,
                                  height: 1,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (AppConfig.showDiscountPercentage &&
                                  widget.product?.formattedSalePrice != null)
                                Container(
                                  decoration: BoxDecoration(
                                      color: moveColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(3)),
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  child: CustomText(
                                    calculateDiscount(
                                        salePriceTotal: widget.product?.salePrice ?? 0,
                                        priceTotal: widget.product?.price ?? 0),
                                    color: moveColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                            ],
                          ),
                          //if (widget.product?.hasOptions == true || widget.product?.hasFields == true)
                          //  CustomText('متوفر بعدة خيارات'.tr),
                          // if (widget.product?.quantity == 0) CustomText('نفذت الكمية'.tr),
                          const Divider(),
                          GetBuilder<CartLogic>(
                              id: 'addToCart${widget.product!.id!}',
                              init: Get.find<CartLogic>(),
                              autoRemove: false,
                              builder: (cartLogic) {
                                return InkWell(
                                  onTap: () async {
                                    if (widget.product?.hasOptions == true ||
                                        widget.product?.hasFields == true ||
                                        widget.product?.quantity == 0) {
                                      Get.toNamed("/product-details/${widget.product!.id!}",
                                          arguments: {
                                            'backCount': widget.backCount.toString()
                                          });
                                      return;
                                    }
                                    int quantity = 1;

                                    var minQty = widget
                                        .product?.purchaseRestrictions?.minQuantityPerCart;
                                    if (minQty != null) {
                                      if (quantity < minQty) {
                                        quantity = minQty;
                                      }
                                    }
                                    isLoading = true;
                                    setState(() {});
                                    await cartLogic.addToCart(widget.product?.id,
                                        quantity: quantity.toString(),
                                        hasOptions: widget.product?.hasOptions ?? false,
                                        hasFields: widget.product?.hasFields ?? false);

                                    isLoading = false;
                                    _appEvents.logAddToCart(widget.product?.name,
                                        widget.product?.id, widget.product?.price);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppConfig.showButtonWithBorder
                                                ? primaryColor
                                                : Colors.white,
                                            width:
                                            AppConfig.showButtonWithBorder ? 1 : 0.001),
                                        color: AppConfig.showButtonWithBorder
                                            ? Colors.white
                                            : primaryColor,
                                        borderRadius: BorderRadius.circular(15.sp)),
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: isLoading
                                        ? const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                textAddToCartColor),
                                          ),
                                        ))
                                        : Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Row(
                                        children: [
                                          if (widget.product?.quantity != 0 &&
                                              !(widget.product?.hasOptions == true ||
                                                  widget.product?.hasFields == true))
                                            Padding(
                                              padding: const EdgeInsetsDirectional.only(
                                                  start: 10),
                                              child: Image.asset(
                                                iconAddToCart,
                                                scale: 2.5,
                                                color: textAddToCartColor,
                                              ),
                                            ),
                                          Expanded(
                                            child: Center(
                                              child: CustomText(
                                                widget.product?.quantity != 0
                                                    ? (widget.product?.hasOptions ==
                                                    true ||
                                                    widget.product?.hasFields ==
                                                        true)
                                                    ? 'اختر أحد الخيارات'.tr
                                                    : "أضف للسلة".tr
                                                    : 'نبهني عند التوفر'.tr,
                                                color: textAddToCartColor,
                                                textAlign: TextAlign.center,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (widget.product?.quantity != 0 &&
                                              !(widget.product?.hasOptions == true ||
                                                  widget.product?.hasFields == true))
                                            const SizedBox(
                                              width: 15,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (AppConfig.isEnableWishlist)
          PositionedDirectional(
              start: 5,
              width: 35.sp,
              height: 35.sp,
              top: 5,
              child: Container(
                decoration:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100.sp)),
              )),
        if (AppConfig.isEnableWishlist)
          PositionedDirectional(
              start: -30.sp,
              width: 105.sp,
              height: 105.sp,
              top: -30.sp,
              child: GestureDetector(
                onTap: () async {
                  if (!await PrefManger().getIsLogin()) {
                    Get.to(LoginPage());
                    return;
                  }
                  final AppEvents _appEvents = Get.find();

                  _appEvents.logAddToWishlist(
                      widget.product?.name, widget.product?.id, widget.product?.price);
                  var model = WishlistModel(
                    productId: widget.product?.id,
                    productName: widget.product?.name,
                    productImage: widget.product?.images?.isNotEmpty == true
                        ? (widget.product?.images?[0].image?.small)
                        : null,
                    productQuantity: widget.product?.quantity ?? 1,
                    productPrice: widget.product?.price ?? 0,
                    productSalePrice: widget.product?.salePrice ?? 0,
                    productFormattedPrice: widget.product?.formattedPrice,
                    productFormattedSalePrice: widget.product?.formattedSalePrice,
                    productHasFields: widget.product?.hasFields ?? false,
                    productHasOptions: widget.product?.hasOptions ?? false,
                  );
                  if (HiveController.getWishlist().get(widget.product?.id) == null) {
                    await HiveController.getWishlist().put(widget.product?.id, model);
                    clicked = true;
                    //  setState(() {});
                  } else {
                    await HiveController.getWishlist().delete(widget.product?.id);
                    if (widget.forWishlist) {
                      final WishlistLogic logic = Get.find();
                      logic.removeItem(widget.product?.id);
                    }
                    //  setState(() {});
                  }
                },
                child: ValueListenableBuilder<Box<WishlistModel>>(
                    valueListenable: HiveController.getWishlist().listenable(),
                    builder: (context, box, _) {
                      return !clicked
                          ? Icon(
                        Icons.favorite,
                        size: 20.sp,
                        color: HiveController.getWishlist().get(widget.product?.id) == null
                            ? Colors.grey.shade400
                            : moveColor,
                      )
                          : Lottie.asset('assets/images/lf30_editor_omnqgnhv.json',
                          onLoaded: (LottieComposition l) {
                            Future.delayed(
                                Duration(milliseconds: l.duration.inMilliseconds - 1500))
                                .then((value) {
                              clicked = false;
                              setState(() {});
                            });
                          }, repeat: false, animate: true);
                    }),
              )),
      ],
    );
  }
}
