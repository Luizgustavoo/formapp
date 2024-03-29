import 'package:formapp/app/modules/message/message_controller.dart';
import 'package:formapp/app/modules/people/people_controller.dart';
import 'package:get/get.dart';

class MessageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<PeopleController>(() => PeopleController());
  }
}
