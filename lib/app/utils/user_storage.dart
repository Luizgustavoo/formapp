import 'package:get_storage/get_storage.dart';

class UserStorage {
  static final _box = GetStorage('credenciado');

  static bool existUser() {
    if (_box.read('auth') != null) {
      return true;
    }
    return false;
  }

  static String getToken() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    if (existUser()) {
      return _box.read('auth')['access_token'];
    }
    return "";
  }

  static void clearBox() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    if (existUser()) {
      _box.erase();
    }
  }

  static int getUserId() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    if (existUser()) {
      return _box.read('auth')['user']['id'];
    }
    return 0;
  }

  static String getUserName() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    if (existUser()) {
      return _box.read('auth')['user']['nome'];
    }
    return "";
  }

  static int getUserType() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    if (existUser()) {
      return _box.read('auth')['user']['tipousuario_id'];
    }
    return 0;
  }

  static int getFamilyId() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    if (existUser() && getUserType() == 3) {
      return _box.read('auth')['user']['familia_id'];
    }
    return 0;
  }
}
