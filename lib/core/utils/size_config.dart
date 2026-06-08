import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    
    // Scale reference based on iPhone 11 (375x812)
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double getScaledWidth(double inputWidth) {
    // Reference design width: 375
    return (inputWidth / 375.0) * screenWidth;
  }

  static double getScaledHeight(double inputHeight) {
    // Reference design height: 812
    return (inputHeight / 812.0) * screenHeight;
  }

  static double getScaledFontSize(double baseFontSize) {
    // Basic scaling based on width
    double scale = screenWidth / 375.0;
    // Don't let fonts grow too huge on desktop
    if (scale > 1.5) scale = 1.5;
    return baseFontSize * scale;
  }
}

extension SizeConfigExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 650;
  bool get isTablet => screenWidth >= 650 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
}

// Ext for number literals e.g. 20.w, 15.h, 12.sp
extension SizeExtension on num {
  double get w => SizeConfig.getScaledWidth(this.toDouble());
  double get h => SizeConfig.getScaledHeight(this.toDouble());
  double get sp => SizeConfig.getScaledFontSize(this.toDouble());
}
