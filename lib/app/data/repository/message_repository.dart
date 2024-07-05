import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/message_model.dart';
import 'package:ucif/app/data/models/unread_message_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/message_provider.dart';
import 'package:ucif/app/utils/error_handler.dart';

class MessageRepository {
  final MessageApiClient apiClient = MessageApiClient();

  getAll(String token) async {
    List<Message> list = <Message>[];

    var response = await apiClient.getAll(token);

    if (response != null) {
      response.forEach((e) {
        list.add(Message.fromJson(e));
      });
    }

    return list;
  }

  getAllUnreadMessage(String token) async {
    List<UnreadMessage> list = <UnreadMessage>[];

    var response = await apiClient.getAllUnreadMessage(token);

    if (response != null) {
      response.forEach((e) {
        list.add(UnreadMessage.fromJson(e));
      });
    }

    return list;
  }

  insertMessage(
      String token, Family? family, Message message, User? user) async {
    try {
      var response =
          await apiClient.insertMessage(token, family, message, user);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  messageChange(String token, int mensagemId, int userId) async {
    try {
      var response = await apiClient.messageChange(token, mensagemId, userId);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }
}
