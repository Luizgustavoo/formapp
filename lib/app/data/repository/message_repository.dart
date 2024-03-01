import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:formapp/app/data/provider/message_provider.dart';

class MessageRepository {
  final MessageApiClient apiClient = MessageApiClient();

  insertMessage(String token, Family family, Message message) async {
    try {
      var response = await apiClient.insertMessage(token, family, message);

      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }
}
