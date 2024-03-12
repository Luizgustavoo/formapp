import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:formapp/app/data/models/user_model.dart';
import 'package:formapp/app/data/provider/message_provider.dart';

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

  insertMessage(
      String token, Family? family, Message message, User? user) async {
    try {
      var response =
          await apiClient.insertMessage(token, family, message, user);

      return response;
    } catch (e) {
      print('Erro ao enviar mensagem para a família: $e');
      rethrow;
    }
  }

  messageChange(String token, Message message, User? user) async {
    try {
      var response = await apiClient.messageChange(token, message, user);

      return response;
    } catch (e) {
      print('Erro ao enviar mensagem para a família: $e');
      rethrow;
    }
  }
}
