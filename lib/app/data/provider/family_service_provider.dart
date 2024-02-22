import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:http/http.dart' as http;

class FamilyServiceApiClient {
  final http.Client httpClient = http.Client();
  final DatabaseHelper localDatabase = DatabaseHelper();

  /*SALVAR DADOS OFFLINE DO ATENDIMENTO */
  Future<void> saveFamilyServiceLocally(
      Map<String, dynamic> familyServiceData) async {
    await localDatabase.insert(familyServiceData, 'family_service_table');
  }

  Future<List<Map<String, dynamic>>> getAllFamilyServiceLocally() async {
    return await localDatabase.getAllDataLocal('family_service_table');
  }

  Future<void> saveFamilyServiceLocal(FamilyService familyService) async {
    final familyServiceData = {
      'data_atendimento': familyService.dataAtendimento,
      'assunto': familyService.assunto,
      'descricao': familyService.descricao,
      'usuario_id': familyService.usuarioId,
      'data_cadastro': familyService.dataCadastro,
      'data_update': familyService.dataUpdate,
      'pessoa_id': familyService.pessoaId,
    };

    // Se não houver conectividade, salva localmente
    await saveFamilyServiceLocally(familyServiceData);
  }
}
