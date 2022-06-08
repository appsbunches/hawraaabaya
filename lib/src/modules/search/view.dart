import 'dart:async';
import 'dart:developer';
import 'dart:io';

import '../../colors.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/item_product.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SearchPage extends StatefulWidget {
  final String? searchQ;
  SearchPage({Key? key, this.searchQ}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchLogic logic = Get.put(SearchLogic());

  late ScrollController scrollController;

  void _reviewsScrollListener() async {
    try {
      var scrollable = Platform.isAndroid
          ? !scrollController.position.outOfRange
          : scrollController.position.outOfRange;
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          scrollable && logic.isUnderLoading == false) {
        if (logic.next != null) {
          logic.isUnderLoading = true;
          ++logic.mPage;
          logic.getProductsList(q: logic.lastValue, page: logic.mPage, forPagination: true);
        }
      }
    } catch (e) {}
  }

  @override
  initState(){

   if( widget.searchQ != null){
     logic.searchController.text=widget.searchQ ?? '';
     logic.getProductsList(page: 1, forPagination: false , q:widget.searchQ  );
   }else{
     logic.searchController.text= '';

   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController = ScrollController();
    scrollController.addListener(_reviewsScrollListener);

    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          title: CustomText(
            "البحث".tr,
            fontSize: 16,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Image.asset(iconLogo),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            logic.mPage = 1;
            return logic.getProductsList(
                q: logic.lastValue, page: logic.mPage, forPagination: false);
          },
          child: SizedBox(
            height: double.infinity,
            child: GetBuilder<SearchLogic>(
                id: "products",
                builder: (logic) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      (logic.isProductsLoading)
                      ?  const CustomProgressIndicator() : const SizedBox(height: 4,),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        margin: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20.sp)),
                        child: TextField(
                          controller: logic.searchController,
                          textInputAction: TextInputAction.search,
                          //  onChanged: logic.onChangeSearchField,
                          onSubmitted: (val) {
                            logic.mPage = 1;
                            logic.getProductsList(q: val, page: logic.mPage, forPagination: false);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ابحث هنا'.tr,
                              suffixIcon: GestureDetector(
                                  onTap: () => logic.searchController.text = '',
                                  child: const Icon(
                                    Icons.highlight_remove_outlined,
                                    color: primaryColor,
                                  )),
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      iconSearch,
                                      scale: 2,
                                    )),
                              )),
                        ),
                      ),
                      Expanded(
                        child: logic.productsList.isNotEmpty
                            ? SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              GridView.builder(
                                itemCount: logic.productsList.length,
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.55),
                                itemBuilder: (context, index) =>
                                    ItemProduct(
                                      logic.productsList[index],
                                      backCount: 2,
                                      horizontal: false,
                                      forWishlist: false,
                                    ),
                              ),
                              if (logic.isUnderLoading)
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                        )


                            : logic.isProductsLoading? SizedBox()

                            : Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.only(left: 50, right: 50, bottom: 100),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 80.sp,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomText(
                                "لم نعثر على نتائج بحث".tr,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}
