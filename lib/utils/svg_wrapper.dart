import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWrapper {
  final String rawSvg;

  SvgWrapper(this.rawSvg);

  Future<DrawableRoot> generateLogo() async {
    DrawableRoot? val;
    try {
      val = await svg.fromSvgString(rawSvg, rawSvg);
      return val;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return val!;
  }
}
