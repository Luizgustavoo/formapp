import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/provider/family_service_provider.dart';

class FamilyServiceRepository {
  final FamilyServiceApiClient apiClient = FamilyServiceApiClient();

  insertService(String token, FamilyService familyService) async {
    try {
      var response = await apiClient.insertService(token, familyService);

      return response;
    } catch (e) {
      print('Erro ao inserir o atendimento: $e');
      rethrow;
    }
  }

  saveFamilyServiceLocal(FamilyService familyService) async {
    try {
      var response = await apiClient.saveFamilyServiceLocal(familyService);
      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }
}