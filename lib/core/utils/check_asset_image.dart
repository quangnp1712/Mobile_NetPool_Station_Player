import 'package:flutter/services.dart' show rootBundle;

class CheckIfAssetImageExists {
  static Future<bool> checkIfAssetImageExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
