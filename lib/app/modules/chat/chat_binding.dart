import 'package:get/get.dart';
import 'package:ucif/app/data/repository/chat_repository.dart';
import 'package:ucif/app/modules/chat/chat_controller.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ChatRepository>(() => ChatRepository());
  }
}
