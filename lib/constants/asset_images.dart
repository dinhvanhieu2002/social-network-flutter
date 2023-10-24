import 'package:flutter/widgets.dart';

class AssetImages {
  // Đường dẫn đến hình ảnh background.png trong assets/images
  static final backgroundImage = Image.asset(
    'assets/images/background.png',
    fit: BoxFit.cover,
  );

  // Đường dẫn đến hình ảnh instagram.png trong assets/images
  static final instagramImage = Image.asset(
    'assets/images/instagram.png',
    fit: BoxFit.contain,
  );
}


