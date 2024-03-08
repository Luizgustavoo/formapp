import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class ShowcaseController extends GetxController {
  final box = GetStorage();

  static const Map<String, String> PREFERENCES_IS_FIRST_LAUNCH_STRINGS = {
    'family1': "PREFERENCES_IS_FIRST_LAUNCH_OTHER_SCREEN",
    'family': "PREFERENCES_IS_FIRST_LAUNCH_FAMILY",
  };

  Future<bool> isFirstLaunch(String screenName) async {
    String? prefKey = PREFERENCES_IS_FIRST_LAUNCH_STRINGS[screenName];
    if (prefKey == null) {
      throw Exception("Screen name not found in preferences mapping");
    }

    bool isFirstLaunch = box.read(prefKey) ?? true;

    if (isFirstLaunch) {
      box.write(prefKey, false);
    }

    return isFirstLaunch;
  }
}
