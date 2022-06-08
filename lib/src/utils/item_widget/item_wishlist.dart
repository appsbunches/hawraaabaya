import '../../../main.dart';
import '../../entities/product_details_model.dart';
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

class ItemWishlist extends StatefulWidget {
  final WishlistModel? product;
  final int backCount;
  final int index;

  const ItemWishlist(this.product, this.index, {Key? key, required this.backCount})
      : super(key: key);

  @override
  State<ItemWishlist> createState() => _ItemWishlistState();
}

class _ItemWishlistState extends State<ItemWishlist> {
  final AppEvents _appEvents = Get.find();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.sp),
      onTap: () => widget.product == null
          ? () {}
          : Get.toNamed("/product-details/${widget.product!.productId!}",
              preventDuplicates: false, arguments: {'backCount': widget.backCount.toString()}),
      // onTap: () => Get.to(ProductDetailsPage(product!.id!)),
      child: widget.product?.productQuantity == 0
          ? ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.saturation,
              ),
              child: buildContainer(),
            )
          : buildContainer(),
    );
  }

  Container buildContainer() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                        PositionedDirectional(
                          start: 0,
                          end: 0,
                          bottom: 0,
                          top: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: CustomImage(
                              url: widget.product?.productImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (AppConfig.isEnableWishlist)
                          PositionedDirectional(
                            top: 5,
                            child: GestureDetector(
                                onTap: () async {
                                  _appEvents.logAddToWishlist(widget.product?.productName,
                                      widget.product?.productId, widget.product?.productPrice);
                                  var model = WishlistModel(
                                    productId: widget.product?.productId,
                                    productName: widget.product?.productName,
                                    productImage: widget.product?.productImage,
                                    productQuantity: widget.product?.productQuantity ?? 1,
                                    productPrice: widget.product?.productPrice ?? 0,
                                    productSalePrice: widget.product?.productSalePrice ?? 0,
                                    productFormattedPrice: widget.product?.productFormattedPrice,
                                    productFormattedSalePrice:
                                        widget.product?.productFormattedSalePrice,
                                    productHasFields: widget.product?.productHasFields ?? false,
                                    productHasOptions: widget.product?.productHasOptions ?? false,
                                  );
                                  if (HiveController.getWishlist().get(widget.product?.productId) ==
                                      null) {
                                    await HiveController.getWishlist()
                                        .put(widget.product?.productId, model);
                                    setState(() {});
                                  } else {
                                    await HiveController.getWishlist()
                                        .delete(widget.product?.productId);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: HiveController.getWishlist()
                                                  .get(widget.product?.productId) !=
                                              null
                                          ? moveColor
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(20.sp)),
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5, bottom: 4, top: 6),
                                  child: Icon(
                                    Icons.favorite_sharp,
                                    size: 20.h,
                                    color:
                                        HiveController.getWishlist().get(widget.product?.productId) !=
                                                null
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                  ),
                                )),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(6.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            widget.product?.productName,
                            fontWeight: FontWeight.w800,
                            maxLines:  2,
                            fontSize: 9,
                          ),
                        ),
                        if (widget.product?.productFormattedSalePrice != null)
                          CustomText(
                            widget.product?.productFormattedSalePrice,
                            color: Colors.black,
                            lineThrough: true,
                            fontSize: 9,
                            //fontWeight: FontWeight.w800,
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomText(
                                widget.product?.productFormattedSalePrice ??
                                    widget.product?.productFormattedPrice,
                                color: widget.product?.productFormattedSalePrice != null
                                    ? moveColor
                                    : Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (AppConfig.showDiscountPercentage &&
                                widget.product?.productFormattedSalePrice != null)
                              Container(
                                decoration: BoxDecoration(
                                    color: moveColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(3)),
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                child: CustomText(
                                  calculateDiscount(
                                      salePriceTotal: widget.product?.productSalePrice ?? 0,
                                      priceTotal: widget.product?.productPrice ?? 0),
                                  color: moveColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                          ],
                        ),
                        /*
                        if (widget.product?.productHasOptions == true ||
                            widget.product?.productHasFields == true)
                          CustomText('متوفر بعدة خيارات'.tr),
                        if (widget.product?.productQuantity == 0) CustomText('نفذت الكمية'.tr),
                        const SizedBox(
                          height: 5,
                        ),*/
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: GetBuilder<CartLogic>(
                                  id: 'addToCart${widget.product!.productId!}',
                                  init: Get.find<CartLogic>(),
                                  autoRemove: false,
                                  builder: (cartLogic) {
                                    return InkWell(
                                      onTap: () async {
                                        if (widget.product?.productHasOptions == true ||
                                            widget.product?.productHasFields == true ||
                                            widget.product?.productQuantity == 0) {
                                          Get.toNamed(
                                              "/product-details/${widget.product!.productId!}",
                                              arguments: {
                                                'backCount': widget.backCount.toString()
                                              });
                                          return;
                                        }

                                        isLoading = true;
                                        setState(() {});
                                        await cartLogic.addToCart(widget.product?.productId,
                                            quantity: 1.toString(),
                                            hasOptions: widget.product?.productHasOptions ?? false,
                                            hasFields: widget.product?.productHasFields ?? false);

                                        isLoading = false;
                                        _appEvents.logAddToCart(
                                            widget.product?.productName,
                                            widget.product?.productId,
                                            widget.product?.productPrice);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppConfig.showButtonWithBorder
                                                    ? primaryColor
                                                    : Colors.white,
                                                width: AppConfig.showButtonWithBorder ? 1 : 0.001),
                                            color: AppConfig.showButtonWithBorder
                                                ? Colors.white
                                                : addToCartColor,
                                            borderRadius: BorderRadius.circular(15.sp)),
                                        padding: EdgeInsets.all(6.sp),
                                        child: isLoading
                                            ? const Center(
                                                child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(progressColor),
                                                ),
                                              ))
                                            : Row(
                                                children: [
                                                  if (widget.product?.productQuantity != 0)
                                                    Image.asset(
                                                      iconAddToCart,
                                                      scale: 2.5,
                                                      color: textAddToCartColor,
                                                    ),
                                                  Expanded(
                                                    child: CustomText(
                                                      (widget.product?.productHasOptions == true ||
                                                              widget.product?.productHasFields ==
                                                                  true)
                                                          ? 'اختر أحد الخيارات'.tr
                                                          : widget.product?.productQuantity != 0
                                                              ? "أضف للسلة".tr
                                                              : 'نبهني عند التوفر'.tr,
                                                      color: textAddToCartColor,
                                                      textAlign: TextAlign.center,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
