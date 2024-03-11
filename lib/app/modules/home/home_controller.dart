// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var box;
  RxString username = "".obs;

  // final NotificationSetUp _noti = NotificationSetUp();

  var context = Get.context;

  @override
  void onInit() async {
    username.value = UserStorage.getUserName() ?? "Sem dados";

    // _noti.configurePushNotification(context!);
    // _noti.eventListenerCallback(context!);
    super.onInit();
  }

  void exit() {
    final box = GetStorage('credenciado');
    box.erase();

    Get.offAllNamed('/login');
  }
}
