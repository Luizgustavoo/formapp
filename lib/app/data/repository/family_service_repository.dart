import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/family_service_model.dart';
import 'package:ucif/app/data/provider/family_service_provider.dart';
import 'package:ucif/app/utils/error_handler.dart';

class FamilyServiceRepository {
  final FamilyServiceApiClient apiClient = FamilyServiceApiClient();

  insertService(
      String token, FamilyService familyService, Family family) async {
    try {
      var response =
          await apiClient.insertService(token, familyService, family);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  updateService(String token, FamilyService familyService) async {
    try {
      var response = await apiClient.updateService(token, familyService);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }
}
