import 'package:ucif/app/data/models/count_families_and_people.dart';
import 'package:ucif/app/data/models/genre_model.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/provider/home_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';

class HomeRepository {
  final HomeApiClient apiClient = HomeApiClient();

  Future<List<Genre>> getCountGenre() async {
    var response = await apiClient.getCountGenre();
    if (response != null) {
      List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response);
      List<Genre> genre = responseData.map((e) => Genre.fromJson(e)).toList();

      return genre;
    }
    return [];
  }

  Future<CountFamiliesAndPeople> getCountFamiliesAndPeople() async {
    var response = await apiClient.getCountFamiliesAndPeople();

    CountFamiliesAndPeople count = CountFamiliesAndPeople.fromJson(response);

    return count;
  }

  getPeoples(String token, {int? page, String? search}) async {
    List<People> list = <People>[];

    if (await ConnectionStatus.verifyConnection()) {
      var response =
          await apiClient.getPeoples(token, page: page, search: search);
      List<People> newPeoples = [];
      response['data'].forEach((e) {
        People p = People.fromJson(e);
        newPeoples.add(p);
      });
      if (page == 1) {
        list.clear();
      }
      for (var family in newPeoples) {
        if (!list.contains(family)) {
          list.add(family);
        }
      }
    }
    return list;
  }
}
