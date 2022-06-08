import 'package:entaj/src/utils/custom_widget/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_config.dart';
import '../../../colors.dart';
import '../../../entities/module_model.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';

class BannerWidget extends StatelessWidget {
  final Settings banner;

  const BannerWidget({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConfig.paddingBetweenWidget),
      child: InkWell(
          onTap: () => goToLink(banner.url ?? ''),
          child: Stack(
            children: [
              CustomImage(url: banner.mobileImage ?? banner.image),
              PositionedDirectional(
                end: banner.textPositionRight == true ? null : 10,
                start: 10,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      banner.title,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex(banner.textColor ?? '#fffff'),
                    ),
                    CustomText(
                      banner.subtitle,
                      fontSize: 14,
                      color: HexColor.fromHex(banner.textColor ?? '#fffff'),
                    ),
                    if (banner.showButton == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        child: CustomButtonWidget(
                            title: banner.buttonText ?? '',
                            width: (banner.buttonText?.length ?? 0) * 20,
                            textColor: HexColor.fromHex(banner.buttonTextColor ?? '#fffff'),
                            color: HexColor.fromHex(banner.buttonBgColor ?? '#fffff'),
                            textSize: 16,
                            radius: 3,
                            onClick: () => goToLink(banner.url)),
                      )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
