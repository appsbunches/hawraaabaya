import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../../utils/custom_widget/custom_text.dart';
import '../logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../images.dart';
import '../../../services/app_events.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/functions.dart';
import '../../_main/tabs/cart/logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductAddToCartWidget extends StatefulWidget {
  final String mProductId;
  final AppEvents _appEvents;
  final FocusNode phoneNumberFocusNode;

  const ProductAddToCartWidget(this.mProductId, this.phoneNumberFocusNode, this._appEvents,
      {Key? key})
      : super(key: key);

  @override
  State<ProductAddToCartWidget> createState() => _ProductAddToCartWidgetState();
}

class _ProductAddToCartWidgetState extends State<ProductAddToCartWidget> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    widget.phoneNumberFocusNode.addListener(() {
      bool hasFocus = widget.phoneNumberFocusNode.hasFocus;
      if (hasFocus) {
        showOverlay(context);
      } else {
        log('message');
        removeOverlay();
      }
      setState(() {});
    });
    super.initState();
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return PositionedDirectional(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          start: 0,
          height: 45.h,
          end: 0,
          child: Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: const Text("Done",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ),
          ));
    });

    overlayState?.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

/*
  @override
  void dispose() {
    removeOverlay();

    widget.phoneNumberFocusNode.dispose();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsLogic>(
        init: Get.find<ProductDetailsLogic>(),
        id: widget.mProductId,
        builder: (logic) {
          return !AppConfig.enhancementsV1
              ? SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () => logic.increaseQuantity(),
                          child: const Card(
                            child: Icon(Icons.add),
                            margin: EdgeInsetsDirectional.only(start: 0, end: 5),
                          )),
                      SizedBox(
                        width: 55.h,
                        child: Center(
                          child: GetBuilder<ProductDetailsLogic>(
                              id: 'quantity',
                              builder: (logic) {
                                return TextField(
                                  controller: logic.quantityController,
                                  textAlign: TextAlign.center,
                                  maxLength: 4,
                                  textDirection: TextDirection.ltr,
                                  onChanged: (s) {
                                    if (s.isEmpty) {
                                      return;
                                    }
                                    logic.quantityController.text = replaceArabicNumber(s);
                                    logic.quantityController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: logic.quantityController.text.length));

                                    var inputQty =
                                        int.parse(logic.quantityController.text.toString());
                                    var maxQuantityPerCart = logic
                                        .productModel?.purchaseRestrictions?.maxQuantityPerCart;
                                    var productQuantity = logic.productModel?.quantity;
                                    log('productQty $productQuantity --- inputQty $inputQty');

                                    if (maxQuantityPerCart != null && productQuantity != null) {
                                      if (productQuantity < maxQuantityPerCart) {
                                        if (inputQty >= productQuantity) {
                                          logic.quantityController.text =
                                              productQuantity.toString();

                                          return;
                                        }
                                      } else {
                                        if (inputQty >= maxQuantityPerCart) {
                                          logic.quantityController.text =
                                              maxQuantityPerCart.toString();

                                          return;
                                        }
                                      }
                                    }
                                    if (maxQuantityPerCart != null) {
                                      if (inputQty >= maxQuantityPerCart) {
                                        logic.quantityController.text =
                                            maxQuantityPerCart.toString();
                                        return;
                                      }
                                    }
                                    if (logic.productModel!.quantity == null) return;

                                    if (logic.productModel?.purchaseRestrictions
                                            ?.maxQuantityPerCart !=
                                        null) {
                                      if (inputQty >=
                                          logic.productModel!.purchaseRestrictions!
                                              .maxQuantityPerCart!) {
                                        logic.quantityController.text = logic
                                            .productModel!.purchaseRestrictions!.maxQuantityPerCart!
                                            .toString();
                                        return;
                                      }
                                    } else if (productQuantity < inputQty) {
                                      logic.quantityController.text =
                                          (logic.productModel!.quantity).toString();
                                      return;
                                    }
                                  },
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    // FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(counter: SizedBox.shrink()),
                                  style: TextStyle(fontSize: 16.sp),
                                );
                              }),
                        ),
                      ),
                      GestureDetector(
                          onTap: () => logic.decreaseQuantity(),
                          child: const Card(child: Icon(Icons.remove))),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Stack(
                            children: [
                              GetBuilder<CartLogic>(
                                  init: Get.find<CartLogic>(),
                                  id: 'addToCart${widget.mProductId}',
                                  autoRemove: false,
                                  builder: (cartLogic) {
                                    return CustomButtonWidget(
                                      title: "أضف للسلة",
                                      height: double.infinity,
                                      loading: cartLogic.isCartLoading,
                                      textColor: textAddToCartColor,
                                      color: AppConfig.showButtonWithBorder
                                          ? Colors.white
                                          : primaryColor,
                                      onClick: () async {
                                        logic.update([widget.mProductId]);
                                        var minQty = logic
                                            .productModel?.purchaseRestrictions?.minQuantityPerCart;
                                        var maxQty = logic
                                            .productModel?.purchaseRestrictions?.maxQuantityPerCart;
                                        if (minQty != null) {
                                          if ((int.tryParse(logic.quantityController.text) ?? 0) <
                                              minQty) {
                                            showMessage(
                                                isArabicLanguage
                                                    ? "أقل كمية مسموح بها $minQty وأقصى كمية $maxQty"
                                                    : 'The minimum allowed quantity is $minQty and the maximum quantity is $maxQty',
                                                2);
                                            return;
                                          }
                                        }
                                        var productId = logic.getProductId();

                                        widget._appEvents.logAddToCart(logic.productModel?.name,
                                            logic.productModel?.id, logic.productModel?.price);

                                        await cartLogic.addToCart(
                                          productId,
                                          context: context,
                                          quantity: logic.quantityController.text,
                                          customUserInputFieldRequest: logic.getCustomList(),
                                          hasOptions: logic.productModel?.hasOptions ?? false,
                                          hasFields: logic.productModel?.hasFields ?? false,
                                        );

                                        logic.update([widget.mProductId]);
                                      },
                                    );
                                  }),
                              Positioned(
                                  top: 0,
                                  bottom: 0,
                                  child: Image.asset(
                                    iconCart,
                                    scale: 2,
                                    color: textAddToCartColor,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      if (AppConfig.showWhatsAppIconInProductPage)
                        Container(
                          decoration: BoxDecoration(
                              color: primaryColor, borderRadius: BorderRadius.circular(15.sp)),
                          height: double.infinity,
                          margin: const EdgeInsetsDirectional.only(start: 5),
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
                        )
                    ],
                  ))
              : Padding(
                  padding: EdgeInsets.only(bottom: overlayEntry == null ? 0 : 45.h),
                  child: SizedBox(
                    height: 45.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: GetBuilder<ProductDetailsLogic>(
                              id: 'price',
                              init: Get.find<ProductDetailsLogic>(),
                              builder: (logic) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (logic.productModel?.formattedSalePrice != null)
                                            CustomText(
                                              logic.formattedPrice,
                                              color: formattedSalePriceTextColor,
                                              lineThrough: true,
                                              fontSize: 10,
                                              //fontWeight: FontWeight.w800,
                                            ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child: CustomText(
                                                  logic.salePriceTotal != 0
                                                      ? logic.formattedSalePrice
                                                      : logic.formattedPrice,
                                                  color:
                                                      logic.productModel?.formattedSalePrice != null
                                                          ? formattedPriceTextColorWithSale
                                                          : formattedPriceTextColorWithoutSale,
                                                  fontSize: 12,
                                                  maxLines: 1,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              if (logic.salePriceTotal > 0.0 &&
                                                  logic.priceTotal > 0.0 &&
                                                  AppConfig.showDiscountPercentage)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: moveColor.withOpacity(0.15),
                                                      borderRadius: BorderRadius.circular(3)),
                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 3, vertical: 1),
                                                  child: CustomText(
                                                    calculateDiscount(
                                                        salePriceTotal:
                                                            logic.productModel?.salePrice ?? 0,
                                                        priceTotal: logic.productModel?.price ?? 0),
                                                    color: moveColor,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 150.w,
                          child: GetBuilder<CartLogic>(
                              init: Get.find<CartLogic>(),
                              id: 'addToCart${widget.mProductId}',
                              autoRemove: false,
                              builder: (cartLogic) {
                                return cartLogic.checkIfExist(logic.getProductId())
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: primaryColor),
                                        height: double.infinity,
                                        padding: EdgeInsets.only(
                                            bottom: 7.h, left: 15, top: 7.h, right: 15),
                                        child: GetBuilder<ProductDetailsLogic>(
                                            id: 'quantity',
                                            builder: (logic) {
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  logic.quantityController.text == '1'
                                                      ? GestureDetector(
                                                          onTap: () => cartLogic
                                                              .deleteItemFromProductDetailsPage(
                                                                  cartLogic
                                                                      .getCartItem(
                                                                          logic.getProductId())
                                                                      ?.id,
                                                                  widget.mProductId),
                                                          child: Image.asset(
                                                            iconRemove,
                                                            scale: 2.2,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () => logic.decreaseQuantity(),
                                                          child: const Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                  Expanded(
                                                      child: TextField(
                                                    textAlignVertical: TextAlignVertical.center,
                                                    controller: logic.quantityController,
                                                    textAlign: TextAlign.center,
                                                    maxLength: 4,
                                                    textDirection: TextDirection.ltr,
                                                    onChanged: (s) {
                                                      if (onChange(s, logic, cartLogic)) {}
                                                      cartLogic.increaseQuantity(
                                                          cartLogic
                                                              .getCartItem(logic.getProductId()),
                                                          newQty1: int.parse(
                                                              logic.quantityController.text));
                                                      logic.update(['quantity']);
                                                    },
                                                    textInputAction: TextInputAction.done,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                    ],
                                                    focusNode: widget.phoneNumberFocusNode,
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(bottom: 10.h),
                                                        counter: const SizedBox.shrink()),
                                                    style: TextStyle(
                                                        fontSize:
                                                            (14 + AppConfig.fontDecIncValue).sp,
                                                        color: Colors.white),
                                                  )),
                                                  GestureDetector(
                                                      onTap: () => logic.increaseQuantity(),
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              );
                                            }),
                                      )
                                    : CustomButtonWidget(
                                        title: "أضف للسلة",
                                        textSize: 12,
                                        radius: 25.sp,
                                        icon: Image.asset(
                                          iconAddToCart,
                                          scale: 2,
                                          color: iconAddToCartColor,
                                        ),
                                        height: double.infinity,
                                        loading: cartLogic.isCartLoading,
                                        textColor: textAddToCartColor,
                                        color: AppConfig.showButtonWithBorder
                                            ? Colors.white
                                            : primaryColor,
                                        onClick: () => addToCart(logic, cartLogic),
                                      );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }

  bool onChange(s, ProductDetailsLogic logic, CartLogic cartLogic) {
    if (s.isEmpty) {
      return false;
    }
    logic.quantityController.text = replaceArabicNumber(s);
    logic.quantityController.selection =
        TextSelection.fromPosition(TextPosition(offset: logic.quantityController.text.length));

    var inputQty = int.parse(logic.quantityController.text.toString());
    var maxQuantityPerCart = logic.productModel?.purchaseRestrictions?.maxQuantityPerCart;
    var productQuantity = logic.productModel?.quantity;
    log('productQty $productQuantity --- inputQty $inputQty');

    if (maxQuantityPerCart != null && productQuantity != null) {
      if (productQuantity < maxQuantityPerCart) {
        if (inputQty >= productQuantity) {
          logic.quantityController.text = productQuantity.toString();

          return false;
        }
      } else {
        if (inputQty >= maxQuantityPerCart) {
          logic.quantityController.text = maxQuantityPerCart.toString();

          return false;
        }
      }
    }
    if (maxQuantityPerCart != null) {
      if (inputQty >= maxQuantityPerCart) {
        logic.quantityController.text = maxQuantityPerCart.toString();
        return false;
      }
    }
    if (logic.productModel!.quantity == null) return false;

    if (logic.productModel?.purchaseRestrictions?.maxQuantityPerCart != null) {
      if (inputQty >= logic.productModel!.purchaseRestrictions!.maxQuantityPerCart!) {
        logic.quantityController.text =
            logic.productModel!.purchaseRestrictions!.maxQuantityPerCart!.toString();
        return false;
      }
    } else if (productQuantity < inputQty) {
      logic.quantityController.text = (logic.productModel!.quantity).toString();
      return false;
    }
    return true;
  }

  addToCart(ProductDetailsLogic logic, CartLogic cartLogic) async {
    logic.update([widget.mProductId]);
    var minQty = logic.productModel?.purchaseRestrictions?.minQuantityPerCart;
    var maxQty = logic.productModel?.purchaseRestrictions?.maxQuantityPerCart;
    if (minQty != null) {
      if ((int.tryParse(logic.quantityController.text) ?? 0) < minQty) {
        if (AppConfig.enhancementsV1) {
          logic.quantityController.text = minQty.toString();
        } else {
          showMessage(
              isArabicLanguage
                  ? "أقل كمية مسموح بها $minQty وأقصى كمية $maxQty"
                  : 'The minimum allowed quantity is $minQty and the maximum quantity is $maxQty',
              2);
          return;
        }
      }
    }
    var productId = logic.getProductId();

    widget._appEvents
        .logAddToCart(logic.productModel?.name, logic.productModel?.id, logic.productModel?.price);

    await cartLogic.addToCart(
      productId,
      context: context,
      quantity: logic.quantityController.text,
      customUserInputFieldRequest: logic.getCustomList(),
      hasOptions: logic.productModel?.hasOptions ?? false,
      hasFields: logic.productModel?.hasFields ?? false,
    );

    logic.update([widget.mProductId]);
  }
}
