import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserStorage {
  static final _box = GetStorage('credenciado');
  static RxString changeName = ''.obs;

  static bool existUser() {
    if (_box.read('auth') != null) {
      return true;
    }
    return false;
  }

  static String getToken() {
    if (existUser()) {
      return _box.read('auth')['access_token'];
    }
    return "";
  }

  static String getUserPhoto() {
    if (existUser()) {
      return _box.read('auth')['user']['foto'] ?? "";
    }
    return "";
  }

  static void clearBox() {
    if (existUser()) {
      _box.erase();
    }
  }

  static int getUserId() {
    if (existUser()) {
      return _box.read('auth')['user']['id'];
    }
    return 0;
  }

  static String getUserName() {
    if (existUser()) {
      return _box.read('auth')['user']['nome'];
    }
    return "";
  }

  static String getUserLogin() {
    if (existUser()) {
      return _box.read('auth')['user']['username'];
    }
    return "";
  }

  static int getPeopleId() {
    if (existUser()) {
      return _box.read('auth')['user']['pessoa_id'];
    }
    return 0;
  }

  static int getUserType() {
    if (existUser()) {
      return _box.read('auth')['user']['tipousuario_id'];
    }
    return 0;
  }

  static int getFamilyId() {
    if (existUser() && getUserType() == 3) {
      return _box.read('auth')['pessoa']['familia_id'] ?? 0;
    }
    return 0;
  }
}
