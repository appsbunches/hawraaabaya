import 'dart:developer';
import 'dart:io';

import '../../app_config.dart';
import '../../colors.dart';
import '../../data/hive/wishlist/hive_controller.dart';
import '../../data/remote/api_requests.dart';
import '../../entities/category_model.dart';
import '../../entities/offer_response_model.dart';
import '../../entities/product_details_model.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';
import '../../utils/item_widget/item_category.dart';
import '../_main/logic.dart';
import '../dialog/filter_dialog.dart';
import '../no_Internet_connection_screen.dart';
import '../../utils/custom_widget/custom_sized_box.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/item_home_category.dart';
import '../../utils/item_widget/item_product.dart';
import '../_main/widgets/my_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../images.dart';
import '../search/view.dart';
import 'logic.dart';

class CategoryDetailsPage extends StatefulWidget {
  final bool hideHeaderFooter;

  const CategoryDetailsPage({this.hideHeaderFooter = false, Key? key}) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> with WidgetsBindingObserver {
  late ScrollController scrollController;
  late CategoryDetailsLogic logic;

  late String categoryId;
  final ApiRequests _apiRequests = Get.find();
  bool hasInternet = true;
  bool isCategoryLoading = false;
  bool isProductsLoading = false;
  bool isUnderLoading = false;
  bool filter = false;
  CategoryModel? categoryModel;
  String? filterUrl;
  String? next;
  int mPage = 1;
  List<String> sortList = [
    'Default'.tr,
    'Newest'.tr,
    'Most Popular'.tr,
    'Low to High'.tr,
    'High to Low'.tr
  ];
  String? selectedSort;
  List<ProductDetailsModel> productsList = [];
  TextEditingController startPriceController = TextEditingController();
  TextEditingController endPriceController = TextEditingController();
  RangeValues rangeValues = const RangeValues(0, 1);
  List<CategoryModel> subCategories = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        FocusScopeNode currentFocus = FocusScope.of(Get.context!);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void openFilterDialog() {
    Get.dialog(buildDialog());
  }

  void goToSearch() {
    Get.to(SearchPage());
  }

  changeRange(RangeValues value) {
    rangeValues = value;
    setState(() {});
    //update(['dialog']);
  }

  getCategoryDetails(String categoryId) async {
    categoryModel = null;
    isCategoryLoading = true;
   // setState(() {});
    //update([categoryId]);
    try {
      var response = await _apiRequests.getCategoryDetails(categoryId);
      categoryModel = CategoryModel.fromJson(response.data['payload']);
      subCategories = categoryModel?.subCategories ?? [];
    } catch (e) {
      //  ErrorHandler.handleError(e);
    }
    isCategoryLoading = false;
    setState(() {});
    //update([categoryId]);
  }

  getProductsList({int page = 1, required bool forPagination}) async {
    // productsList = [];
    hasInternet = true;
    if (productsList.isEmpty) isProductsLoading = true;
    if (forPagination && productsList.isNotEmpty) isUnderLoading = true;
    setState(() {});
    try {
      //update([categoryId, 'products']);
    } catch (e) {}
    try {
      var response = widget.hideHeaderFooter
          ? await _apiRequests.getProductsList(
          page: page,
          listingPriceGte: filter ? startPriceController.text : null,
          listingPriceLte: filter ? endPriceController.text : null)
          : await _apiRequests.getProductsList(
          categoryList: filterUrl != null ? null : [categoryId],
          page: page,
          sale_price__isnull: filterUrl?.contains('sale'),
          ordering: filterUrl?.contains('recent_products') == true ? '-created_at' :  getOrdering(),
          listingPriceGte: filter ? startPriceController.text : null,
          listingPriceLte: filter ? endPriceController.text : null);
      var newList = (response.data['results'] as List)
          .map((element) => ProductDetailsModel.fromJson(element))
          .toList();
      productsList.addAll(newList);

      List<String> productsIds = [];
      productsList.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });
      next = response.data['next'];

      var res = await _apiRequests.getSimpleBundleOffer(productsIds);
      List<OfferResponseModel> offerList =
      (res.data['payload'] as List).map((e) => OfferResponseModel.fromJson(e)).toList();

      productsList.forEach((elementProduct) {
        offerList.forEach((elementOffer) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        });
      });
    } catch (e) {
      hasInternet = await ErrorHandler.handleError(e);
    }
    isProductsLoading = false;
    isUnderLoading = false;
    setState(() {});
    //update([categoryId, 'products']);
  }

  String? getOrdering() {
    if (categoryId == 'arguments') {
      return filterUrl?.contains('sale') == true ? null : 'display_order';
    }
    if (selectedSort == sortList[1]) {
      return 'created_at';
    }
    if (selectedSort == sortList[2]) {
      return 'popularity_order';
    }
    if (selectedSort == sortList[3]) {
      return 'price';
    }
    if (selectedSort == sortList[4]) {
      return '-price';
    }
    return null;
  }

  void onSortChanged(String? value) {
    selectedSort = value;
    clearAndFetch();
    setState(() {});
    //update(['sort']);
  }

  restPrice() {
    filter = false;
    startPriceController.text = '';
    endPriceController.text = '';
    rangeValues = const RangeValues(0, 1);
    clearAndFetch();
    setState(() {});
    //update(['dialog']);
  }

  filterPrices() {
    filter = true;
    clearAndFetch();
    Get.back();
  }

  int getBackCount(String categoryId) {
    int backCount = 1;
    final MainLogic mainLogic = Get.find<MainLogic>();
    var categories = mainLogic.categoriesList;

    categories.forEach((element) {
      if (element.ids.contains(categoryId)) {
        int index = element.ids.indexOf(categoryId);
        int realIndex = element.ids.length - index;
        backCount = realIndex;
      }
    });
    return backCount;
  }

  Future<void> clearAndFetch() async {
    productsList = [];
    next = null;
    mPage = 1;
    await getProductsList(forPagination: false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    categoryId = Get.parameters['categoryId'] ?? '';
    logic = Get.put(CategoryDetailsLogic());
    scrollController = ScrollController();
    startPriceController.text = '';
    endPriceController.text = '';
    filter = false;
    categoryId = categoryId;
    if (categoryId == 'arguments') {
      var argument = Get.arguments as Map;
      filterUrl = argument['filter'];
    } else {
      getCategoryDetails(categoryId);
    }
    clearAndFetch();
    scrollController.addListener(_reviewsScrollListener);

    super.initState();
  }

  void _reviewsScrollListener() async {
    try {
      var scrollable = Platform.isAndroid
          ? !scrollController.position.outOfRange
          : scrollController.position.outOfRange;
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          scrollable &&
          isUnderLoading == false) {
        if (next != null) {
          getProductsList(page: ++mPage, forPagination: true);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDetailsLogic>(
        id: categoryId,
        autoRemove: false,
        builder: (logic) {
          return Scaffold(
            bottomNavigationBar: widget.hideHeaderFooter
                ? null
                : MyBottomNavigation(backCount: getBackCount(categoryId)),
            appBar: widget.hideHeaderFooter
                ? null
                : AppBar(
              actions: [
                InkWell(
                    onTap: () => goToSearch(),
                    child: Image.asset(
                      iconSearch,
                      scale: 2,
                    )),
              ],
              title: CustomText(
                categoryModel?.name,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.grey.shade50,
            body: !hasInternet
                ? const NoInternetConnectionScreen()
                : isCategoryLoading || isProductsLoading
                ? const CustomProgressIndicator()
                : RefreshIndicator(
              onRefresh: () => clearAndFetch(),
              child: Container(
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      buildCategories(logic),
                      if (productsList.isNotEmpty && AppConfig.showSubCategoriesAsGrid ||
                          !AppConfig.showSubCategoriesAsGrid)
                        buildFilter(logic),
                      const SizedBox(
                        height: 10,
                      ),
                      if ((AppConfig.showSubCategoriesAsGrid &&
                          productsList.isNotEmpty) ||
                          (!AppConfig.showSubCategoriesAsGrid))
                        buildProducts(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  GetBuilder<CategoryDetailsLogic> buildProducts() {
    return GetBuilder<CategoryDetailsLogic>(
        id: categoryId,
        builder: (logic) {
          return Column(
            children: [
              isProductsLoading
                  ? const CustomProgressIndicator()
                  : productsList.isEmpty
                  ? SizedBox(
                height: productsList.isEmpty && subCategories.isNotEmpty ? 0 : 500.h,
                child: Center(
                  child: SizedBox(
                      width: double.infinity,
                      child: CustomText(
                        'لا يوجد منتجات حالياً'.tr,
                        textAlign: TextAlign.center,
                      )),
                ),
              )
                  : GridView.builder(
                itemCount: productsList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.55),
                itemBuilder: (context, index) => ItemProduct(
                  productsList[index],
                  backCount: getBackCount(categoryId) + 1,
                  horizontal: false,
                  forWishlist: false,
                ),
              ),
              if (isUnderLoading)
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
            ],
          );
        });
  }

  buildFilter(CategoryDetailsLogic logic) {
    return productsList.isEmpty && subCategories.isNotEmpty
        ? const SizedBox()
        : Row(
      children: [
        Expanded(
            child: InkWell(
              onTap: () => openFilterDialog(),
              child: Container(
                height: 44.h,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15.sp)),
                child: Row(
                  children: [
                    CustomText(
                      "السعر".tr,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Container(
              height: 44.h,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15.sp)),
              child: Row(
                children: [
                  Image.asset(
                    iconFilter,
                    scale: 2,
                  ),
                  Expanded(
                    child: GetBuilder<CategoryDetailsLogic>(
                        id: 'sort',
                        builder: (logic) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              onChanged: onSortChanged,
                              value: selectedSort,
                              hint: SizedBox(
                                child: Row(
                                  children: [
                                    const CustomSizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      sortList.first,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                              items: sortList
                                  .map((e) => DropdownMenuItem(
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      const CustomSizedBox(
                                        width: 5,
                                      ),
                                      CustomText(
                                        e,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                value: e,
                              ))
                                  .toList(),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  buildCategories(CategoryDetailsLogic logic) {
    return GetBuilder<CategoryDetailsLogic>(
        id: categoryId,
        autoRemove: false,
        // init: Get.find<CategoryDetailsLogic>(),
        builder: (context) {
          return isProductsLoading
              ? const SizedBox()
              : (subCategories.isNotEmpty)
              ? (AppConfig.showSubCategoriesAsGrid && productsList.isEmpty ||
              productsList.isEmpty && subCategories.isNotEmpty)
              ? GridView.builder(
              itemCount: subCategories.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1),
              itemBuilder: (context, index) => ItemCategory(subCategories[index], 100))
              : SizedBox(
            height: subCategories.isEmpty
                ? 0
                : AppConfig.showSubCategoriesAsGrid
                ? 170.h
                : 58.h,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: subCategories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return AppConfig.showSubCategoriesAsGrid
                            ? ItemCategory(subCategories[index], 120)
                            : ItemHomeCategory(subCategories[index]);
                      }),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          )
              : const SizedBox();
        });
  }

  buildDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      backgroundColor: Colors.grey.shade100,
      child: SizedBox(
        height: 230.sp,
        width: 300.sp,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.sp),
          child: GetBuilder<CategoryDetailsLogic>(
              id: 'dialog',
              init: Get.find<CategoryDetailsLogic>(),
              builder: (logic) {
                return Column(
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      padding: EdgeInsets.all(15.sp),
                      child: Row(
                        children: [
                          CustomText("السعر".tr, fontWeight: FontWeight.bold),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => restPrice(),
                            child: CustomText(
                              "إعادة ضبط".tr,
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomSizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText("من".tr),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: startPriceController,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    textDirection: TextDirection.ltr,
                                    onChanged: (s) {
                                      startPriceController.text = replaceArabicNumber(s);
                                      startPriceController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: s.length));
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        counter: const SizedBox.shrink(),
                                        hintText:
                                        HiveController.generalBox.get('currency') ?? 'SAR',
                                        contentPadding: EdgeInsets.zero,
                                        border: const OutlineInputBorder()),
                                    style: TextStyle(fontSize: (14 + AppConfig.fontDecIncValue).sp),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText("إلى".tr),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: endPriceController,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    textDirection: TextDirection.rtl,
                                    onChanged: (s) {
                                      endPriceController.text = replaceArabicNumber(s);
                                      endPriceController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: s.length));
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        counter: const SizedBox.shrink(),
                                        hintText:
                                        HiveController.generalBox.get('currency') ?? 'SAR',
                                        contentPadding: EdgeInsets.zero,
                                        border: const OutlineInputBorder()),
                                    style: TextStyle(fontSize: (14 + AppConfig.fontDecIncValue).sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.sp),
                          border: Border.all(color: Colors.grey.shade400),
                          color: Colors.grey.shade200),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              thumbColor: Colors.white,
                              overlayColor: Colors.grey,
                              activeTrackColor: Colors.grey,
                              inactiveTrackColor: Colors.grey.shade400,
                            ),
                            child: RangeSlider(
                              values: rangeValues,
                              onChanged: changeRange,
                            ),
                          ),
                          Row(
                            children: [
                              CustomText(
                                startPriceValue() + " " +"ر.س".tr,
                                fontSize: 10,
                              ),
                              const Spacer(),
                              CustomText(
                                endPriceValue()+ " " +"ر.س".tr,
                                fontSize: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Spacer(),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomButtonWidget(
                        title: "تصفية".tr,
                        onClick: () => filterPrices(),
                        color: Colors.white,
                        textColor: secondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
