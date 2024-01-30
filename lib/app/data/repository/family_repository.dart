import 'dart:convert';

import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/provider/family_provider.dart';

class FamilyRepository {
  final FamilyApiClient apiClient = FamilyApiClient();

  getALl(String token) async {
    List<Family> list = <Family>[];

    var response = await apiClient.getAll(token);

    response.forEach((e) {
      print(Family.fromJson(e).toJson());
      list.add(Family.fromJson(e));
    });

    return list;
  }
}
