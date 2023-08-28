import 'package:offline_subscription/dependencyinjection/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static setLastPurchaseToken(String lastPurchaseToken) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setString("lastPurchaseToken", lastPurchaseToken);
  }

  static String? getLastPurchaseToken() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getString("lastPurchaseToken");
  }

  static setBottomSheetShown(bool isShown) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setBool("isBottomSheetShown", isShown);
  }

  static bool? getBottomSheetShown() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getBool("isBottomSheetShown");
  }
}
