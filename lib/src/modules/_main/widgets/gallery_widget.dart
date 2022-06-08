import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:entaj/src/utils/custom_widget/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/home_screen_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../logic.dart';
import '../tabs/home/logic.dart';

class GalleryWidget extends StatelessWidget {
  final List<Items> galleryItems;
  final String? title;
  final bool showAsColumn;

  const GalleryWidget(
      {Key? key, this.title, required this.galleryItems, required this.showAsColumn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (mainLogic) {
          return GetBuilder<HomeLogic>(
              init: Get.find<HomeLogic>(),
              builder: (logic) {
                logic.getGallery();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget , horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        CustomText(
                          title,
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      if (title != null)
                        const SizedBox(
                          height: 15,
                        ),
                      showAsColumn
                          ? ListView.builder(
                              itemCount: galleryItems.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => galleryItems[index].image == null
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: buildClipRRect(galleryItems[index]),
                                    ))
                          : StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: mapIndexed(
                                  galleryItems,
                                  (index, item) => StaggeredGridTile.count(
                                      crossAxisCellCount:
                                          galleryItems.length.isOdd && index == 0 ? 2 : 1,
                                      mainAxisCellCount:
                                          galleryItems.length.isOdd && index == 0 ? 2 : 1,
                                      child: buildClipRRect(galleryItems[index]))).toList(),
                            ) /*GridView.builder(
                              itemCount: galleryItems.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1),
                              itemBuilder: (context, index) => buildClipRRect(index))*/
                      ,
                    ],
                  ),
                );
              });
        });
  }

  Iterable<E> mapIndexed<E, T>(Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  ClipRRect buildClipRRect(Items galleryItem) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          onTap: () => goToLink(galleryItem.url ?? ''),
          child: Stack(
            children: [
              CustomImage(url: galleryItem.image),
              if (galleryItem.subtitle != null ||
                  galleryItem.title != null ||
                  galleryItem.buttonText != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (galleryItem.subtitle != null)
                        CustomText(
                          galleryItem.subtitle,
                          fontSize: 10,
                          color: HexColor.fromHex(galleryItem.textColor ?? '#fffff'),
                        ),
                      if (galleryItem.title != null)
                        CustomText(
                          galleryItem.title,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex(galleryItem.textColor ?? '#fffff'),
                        ),
                      if (galleryItem.buttonText != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: CustomButtonWidget(
                              title: galleryItem.buttonText ?? '',
                              width: (galleryItem.buttonText?.length ?? 0) * 20,
                              textColor: HexColor.fromHex(galleryItem.buttonColor ?? '#fffff'),
                              color: Colors.transparent,
                              textSize: 16,
                              radius: 3,
                              onClick: () => goToLink(galleryItem.url)),
                        )
                    ],
                  ),
                )
            ],
          )),
    );
  }
}
