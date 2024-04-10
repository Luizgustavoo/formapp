import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/provider/chat_provider.dart';

class ChatRepository {
  final ChatApiClient apiClient = ChatApiClient();

  getAll(String token, int remententeId, int destinatarioId) async {
    List<Chat> list = <Chat>[];

    var response = await apiClient.getAll(token, remententeId, destinatarioId);

    if (response != null) {
      response.forEach((e) {
        list.add(Chat.fromJson(e));
      });
    }

    return list;
  }
}
