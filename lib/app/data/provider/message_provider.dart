import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/message_model.dart';
import 'package:http/http.dart' as http;

class MessageApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();

  /*SALVAR DADOS OFFLINE DA MENSAGEM */
  Future<void> saveMessageLocally(Map<String, dynamic> messageData) async {
    await localDatabase.insert(messageData, 'message_table');
  }

  Future<List<Map<String, dynamic>>> getAllMessageLocally() async {
    return await localDatabase.getAllDataLocal('message_table');
  }

  Future<void> saveMessageLocal(Message message) async {
    final messageData = {
      'data': message.data,
      'titulo': message.titulo,
      'descricao': message.descricao,
      'usuario_id': message.usuarioId,
      'data_cadastro': message.dataCadastro,
      'data_update': message.dataUpdate,
    };

    await saveMessageLocally(messageData);
  }
}
