import 'category_model.dart';
import '../app_config.dart';
import 'home_screen_model.dart';

class ModuleModel {
  ModuleModel.fromJson(dynamic json, filename) {
    id = json['id'];
    storefrontThemeStoreId = json['storefront_theme_store_id'];
    storefrontThemeFileId = json['storefront_theme_file_id'];
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
    isDraft = json['is_draft'];
    draftFor = json['draft_for'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fileName = filename;
  }

  String? id;
  String? storefrontThemeStoreId;
  String? storefrontThemeFileId;
  Settings? settings;
  int? isDraft;
  dynamic draftFor;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? fileName;
}

class Settings {
  List<Links>? links1Links;
  List<Links>? links2Links;
  bool? links1Hide;
  bool? links2Hide;
  List<Items>? slider;
  List<Items>? instagram;
  bool? displayMore;
  bool? hideDots;
  bool? announcementBarDisplay;
  String? links1Title;
  String? links2Title;
  String? textColor;
  String? announcementBarText;
  String? announcementBarPageDisplay;
  String? announcementBarBackgroundColor;
  String? announcementBarTextColor;
  String? announcementBarUrl;
  String? headerLogo;
  String? moreText;
  List<dynamic>? headerOptions;
  String? colorsHeaderBackgroundColor;
  String? colorsHeaderTextColor;
  String? colorsFooterBackgroundColor;
  String? colorsFooterTextColor;
  String? fontsName;
  String? title;
  List<Items>? gallery;
  List<Items>? storePartners;
  List<StoreFeatures>? storeFeatures;
  List<StoreFeatures>? features;
  int? order;
  FeaturedProducts? category;
  FeaturedProducts? products;
  List<Items>? testimonials;
  List<CategoryModel>? categories;
  String? video;
  String? bgColor;
  String? instagramAccount;
  bool? autoplay;
  bool? controls;
  bool? showButton;
  bool? textPositionRight;
  String? subtitle;
  String? image;
  String? mobileImage;
  String? buttonText;
  String? buttonBgColor;
  String? buttonTextColor;
  String? backgroundColor;
  String? url;

  Settings.fromJson(dynamic json) {
    backgroundColor = json['background_color'];
    textPositionRight = json['text_position_right'];
    url = json['url'];
    buttonTextColor = json['button_text_color'];
    buttonBgColor = json['button_bg_color'];
    buttonText = json['button_text'];
    buttonText = json['button_text'];
    showButton = json['show_button'];
    mobileImage = json['mobile_image'] ?? json['image_mobile'] ;
    subtitle = json['subtitle'];
    instagramAccount = json['instagram_account'];
    textColor = json['text_color'];
    bgColor = json['bg_color'];
    video = json['video'];
    autoplay = json['autoplay'];
    controls = json['controls'];
    moreText = json['more_text'];
    try {
      if ((moreText?.length ?? 0) > 16) {
        moreText = moreText?.substring(0, 15);
        moreText = '$moreText...';
      }
    } catch (e) {}
    links1Title = json['links_1_title'];
    links2Title = json['links_2_title'];
    links1Hide = json['links_1_hide'];
    links2Hide = json['links_2_hide'];
    hideDots = json['hide_dots'];
    announcementBarDisplay = json['announcement_bar_display'];
    announcementBarText = json['announcement_bar_text'];
    announcementBarPageDisplay = json['announcement_bar_page_display'];
    announcementBarBackgroundColor = json['announcement_bar_background_color'];
    announcementBarTextColor = json['announcement_bar_text_color'];
    announcementBarUrl = json['announcement_bar_url'];
    headerLogo = json['header_logo'];
    colorsHeaderBackgroundColor = json['colors_header_background_color'];
    colorsHeaderTextColor = json['colors_header_text_color'];
    colorsFooterBackgroundColor = json[AppConfig.isSoreUseNewTheme
        ? 'announcement_bar_text_color'
        : 'colors_footer_background_color'];
    colorsFooterTextColor = json['colors_footer_text_color'];
    fontsName = json['fonts_name'];
    order = json['order'];
    displayMore = json['display_more'];
    title = json['title'];
    category = json['category'] == null ? null : FeaturedProducts.fromJson(json['category']);
    products = json['products'] == null ? null : FeaturedProducts.fromJson(json['products']);

   if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        if(v == null) return;
        categories?.add(CategoryModel.fromJson(v['category'] ?? v));
      });
    }
    if (json['links_1_links'] != null) {
      links1Links = [];
      json['links_1_links'].forEach((v) {
        if (v == null) return;
        var element = Links.fromJson(v);
        if (element.title != null) {
          links1Links?.add(Links.fromJson(v));
        }
      });
    }
    if (json['links_2_links'] != null) {
      links2Links = [];
      json['links_2_links'].forEach((v) {
        if (v == null) return;
        var element = Links.fromJson(v);
        if (element.title != null) {
          links2Links?.add(Links.fromJson(v));
        }
      });
    }
    if (json['slider'] != null) {
      slider = [];
      json['slider'].forEach((v) {
        if (v == null) return;
        slider?.add(Items.fromJson(v));
      });
    }
    if (json['instagram'] != null) {
      instagram = [];
      json['instagram'].forEach((v) {
        if (v == null) return;
        instagram?.add(Items.fromJson(v));
      });
    }
    if (json['header_options'] != null) {
      headerOptions = [];
      json['header_options'].forEach((v) {
        if(v == null) return;
        headerOptions?.add((v));
      });
    }
    if (json['gallery'] != null) {
      gallery = [];
      json['gallery'].forEach((v) {
        if(v == null) return;
        gallery?.add(Items.fromJson(v));
      });
    }
    if (json['store_partners'] != null) {
      storePartners = [];
      json['store_partners'].forEach((v) {
        if(v == null) return;
        storePartners?.add(Items.fromJson(v));
      });
    }
    if (json['testimonials'] != null) {
      testimonials = [];
      json['testimonials'].forEach((v) {
        if(v == null) return;
        testimonials?.add(Items.fromJson(v));
      });
    }
    if (json['store_features'] != null) {
      storeFeatures = [];
      json['store_features'].forEach((v) {
        if(v == null) return;
        storeFeatures?.add(StoreFeatures.fromJson(v));
      });
    }
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        if(v == null) return;
        features?.add(StoreFeatures.fromJson(v));
      });
    }
  }
}


class StoreFeatures {
  StoreFeatures.fromJson(dynamic json) {
    image = json['image'];
    title = json['title'] ?? json['text'];
    textColor = json['text_color'];
  }

  String? image;
  String? title;
  String? textColor;
}

class Links {
  Links.fromJson(dynamic json) {
    title = json['title'];
    url = json['url'];
  }

  String? title;
  String? url;
}
