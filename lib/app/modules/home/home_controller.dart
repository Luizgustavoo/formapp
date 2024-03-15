// ignore_for_file: prefer_typing_uninitialized_variables
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
  RxInt familyUser = 0.obs;
  RxInt allFamily = 0.obs;
  RxInt peopleUser = 0.obs;
  RxInt allPeople = 0.obs;
  RxInt touchedIndex = 0.obs;
  RxList<Genre> genres = <Genre>[].obs;

  @override
  void onInit() async {
    username.value = UserStorage.getUserName();
    getCountGenre();
    super.onInit();
  }

  void logout() {
    repository.getLogout();
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
