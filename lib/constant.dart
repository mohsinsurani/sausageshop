import 'package:flutter/material.dart';

// Color combination for this project
const Color mainText = Color(0xFF2E3E5C);
const Color secondaryText = Color(0xFF9FA5C0);

// Image path config
enum GregImages { chicken, avatar }

extension ImageFormExtension on GregImages {
  String get value {
    const path = "assets/images/";
    final String imageName;
    switch (this) {
      case GregImages.chicken:
        imageName = "chicken.jpeg";
        break;
      case GregImages.avatar:
        imageName = "avatar.jpeg";
        break;
    }
    return "$path$imageName";
  }
}

// Json path config
enum GregData { sausage }

extension GregDataExtension on GregData {
  String get json {
    const path = "assets/json/";
    final String imageName;
    switch (this) {
      case GregData.sausage:
        imageName = "greggs_product.json";
        break;
    }
    return "$path$imageName";
  }
}
