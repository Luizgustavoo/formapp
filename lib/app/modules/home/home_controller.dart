// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';

import 'package:formapp/app/data/models/genre_model.dart';
import 'package:formapp/app/data/repository/auth_repository.dart';
import 'package:formapp/app/data/repository/home_repository.dart';
import 'package:formapp/app/utils/user_storage.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var box;
  RxString username = "".obs;
  final repository = Get.find<AuthRepository>();
  final homeRepository = Get.find<HomeRepository>();
  RxInt familyUser = 150.obs;
  RxInt allFamily = 0.obs;
  RxInt peopleUser = 0.obs;
  RxInt allPeople = 0.obs;
  RxInt touchedIndex = 0.obs;
  RxList<Genre> genres = <Genre>[].obs;

  RxInt number = 0.obs;
  RxInt counter = 0.obs;
  RxBool isNumActive = true.obs;
  late Timer timer;

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (counter < 250) {
        counter++;
      } else {
        timer.cancel(); // Cancela o timer quando o contador atinge 50
      }
    });
  }

  @override
  void onInit() async {
    print('passei no oninit home controller');
    startTimer();
    username.value = UserStorage.getUserName();

    getCountGenre();

    super.onInit();
  }

  void onCountUpdate(num value) {
    number = value as RxInt;
  }

  void onCountDone() {
    isNumActive.value = true;
  }

  void logout() {
    repository.getLogout();
  }

  void updateCounter(int newValue) {
    allFamily.value = newValue;
  }

  getCountGenre() async {
    try {
      List<Genre> genre = await homeRepository.getCountGenre();
      genres.assignAll(genre);
    } catch (e) {
      print(e);
    }
  }
}
