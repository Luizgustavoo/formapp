import 'package:ucif/app/data/models/chat_model.dart';
import 'package:ucif/app/data/provider/chat_provider.dart';
import 'package:ucif/app/utils/error_handler.dart';

class ChatRepository {
  final ChatApiClient apiClient = ChatApiClient();

  getAll(String token, int destinatarioId) async {
    List<Chat> list = <Chat>[];

    var response = await apiClient.getAll(token, destinatarioId);

    if (response != null) {
      response.forEach((e) {
        list.add(Chat.fromJson(e));
      });
    }

    return list;
  }

  sendChat(String token, int destinatarioId, String mensagem) async {
    try {
      var response = await apiClient.sendChat(token, destinatarioId, mensagem);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  chatChange(String token, int destinatarioId) async {
    try {
      var response = await apiClient.chatChange(token, destinatarioId);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }
}
