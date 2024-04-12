import 'dart:async';

import 'package:get/get.dart';
import 'package:ucif/app/data/models/count_families_and_people.dart';
import 'package:ucif/app/data/models/genre_model.dart';
import 'package:ucif/app/data/repository/home_repository.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxString username = "".obs;

  final homeRepository = Get.find<HomeRepository>();
  RxInt familyUser = 150.obs;
  RxInt allFamily = 0.obs;
  RxInt peopleUser = 0.obs;
  RxInt allPeople = 0.obs;
  RxInt touchedIndex = 0.obs;
  RxList<Genre> genres = <Genre>[].obs;

  RxInt number = 0.obs;
  RxBool isNumActive = true.obs;
  RxInt totalFamilies = 0.obs;
  RxInt totalPeoples = 0.obs;

  RxInt counter = 0.obs;
  RxInt counter2 = 0.obs;
  late Timer timer;
  late Timer timer2;

  @override
  void onInit() async {
    bool isConnected = await ConnectionStatus.verifyConnection();
    if (isConnected) {
      await getCountFamiliesAndPeople();
      startTimer();
      username.value = UserStorage.getUserName();
      startTimer();
      await getCountGenre();
      clearTouchedIndex();
    }

    super.onInit();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  void onCountUpdate(num value) {
    number = value as RxInt;
  }

  void onCountDone() {
    isNumActive.value = true;
  }

  void updateCounter(int newValue) {
    allFamily.value = newValue;
  }

  void clearTouchedIndex() {
    touchedIndex.value = -1;
  }

  getCountGenre() async {
    try {
      List<Genre> genre = await homeRepository.getCountGenre();
      genres.assignAll(genre);
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  getCountFamiliesAndPeople() async {
    try {
      CountFamiliesAndPeople resposta =
          await homeRepository.getCountFamiliesAndPeople();
      if (UserStorage.getUserType() == 1) {
        totalFamilies.value = resposta.allFamily;
        totalPeoples.value = resposta.allPeople;
      } else if (UserStorage.getUserType() == 2) {
        totalFamilies.value = resposta.familyUser;
        totalPeoples.value = resposta.peopleUser;
      }
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (counter < totalFamilies.value) {
        counter++;
      } else {
        timer.cancel();
      }
    });
    timer2 = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (counter2 < totalPeoples.value) {
        counter2++;
      } else {
        timer2.cancel();
      }
    });
  }
}
