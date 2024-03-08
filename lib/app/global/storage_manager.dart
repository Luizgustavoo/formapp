import 'package:get_storage/get_storage.dart';

class StorageManager {
  static final _storage = GetStorage('acessos_app_familia');
  static const _key = 'userIds';

  static List getUserIds() {
    // Lê a lista de IDs do armazenamento ou retorna uma lista vazia se não existir
    return _storage.read<List<dynamic>>(_key) ?? [];
  }

  static void addUser(int userId) {
    // Obtém a lista atual de IDs
    List userIds = getUserIds();

    // Adiciona o novo ID à lista
    userIds.add(userId);

    // Salva a lista atualizada de IDs no armazenamento
    _storage.write(_key, userIds);
  }
}
