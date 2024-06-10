import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/data/models/count_families_and_people.dart';
import 'package:ucif/app/data/models/genre_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/repository/home_repository.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';
import 'package:ucif/app/utils/user_storage.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxString username = "".obs;

  RxList<People> listPeoples = <People>[].obs;

  final TextEditingController searchController = TextEditingController();

  RxInt familyUser = 150.obs;
  RxInt allFamily = 0.obs;
  RxInt peopleUser = 0.obs;
  RxInt allPeople = 0.obs;
  RxInt touchedIndex = 0.obs;
  RxList<Genre> genres = <Genre>[].obs;

  RxBool isLoading = true.obs;

  RxBool isDrawerOpen = false.obs;

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void closeDrawer() {
    isDrawerOpen.value = false;
  }

  RxInt number = 0.obs;
  RxBool isNumActive = true.obs;
  RxInt totalFamilies = 0.obs;
  RxInt totalPeoples = 0.obs;
  RxInt totalLider = 0.obs;

  RxInt counter = 0.obs;
  RxInt counter2 = 0.obs;
  RxInt counter3 = 0.obs;
  Timer? timer;
  Timer? timer2;
  Timer? timer3;

  RxBool isGraphicLoading = true.obs;
  @override
  void onInit() async {
    bool isConnected = await ConnectionStatus.verifyConnection();
    if (isConnected) {
      await getCountFamiliesAndPeople();
      startTimer();
      username.value = UserStorage.getUserName();
      startTimer();
      await getCountGenre();
      await getPeoples();

      isGraphicLoading.value = false;
      clearTouchedIndex();
    }

    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    timer2?.cancel();
    timer3?.cancel();
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
      final homeRepository = Get.find<HomeRepository>();
      List<Genre> genre = await homeRepository.getCountGenre();
      genres.assignAll(genre);
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  getCountFamiliesAndPeople() async {
    try {
      final homeRepository = Get.find<HomeRepository>();
      CountFamiliesAndPeople resposta =
          await homeRepository.getCountFamiliesAndPeople();
      if (UserStorage.getUserType() == 1) {
        totalFamilies.value = resposta.allFamily;
        totalPeoples.value = resposta.allPeople;
        totalLider.value = resposta.allLider;
      } else if (UserStorage.getUserType() == 2) {
        totalFamilies.value = resposta.familyUser;
        totalPeoples.value = resposta.peopleUser;
        totalLider.value = resposta.liderUser;
      }
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  void startTimer() {
    // Inicialize `timer`, `timer2` e `timer3` com novos temporizadores
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
        timer2?.cancel();
      }
    });

    timer3 = Timer.periodic(const Duration(milliseconds: 50), (timer3) {
      if (counter3 < totalLider.value) {
        counter3++;
      } else {
        timer3.cancel();
      }
    });
  }

  Future<void> getPeoples({int? page, String? search}) async {
    isLoading.value = true;
    try {
      final repository = Get.put(HomeRepository());
      final token = UserStorage.getToken();
      listPeoples.value = await repository.getPeoples("Bearer $token",
          page: page, search: search);
      update();
    } catch (e) {
      ErrorHandler.showError(e);
    }
    isLoading.value = false;
  }
}
