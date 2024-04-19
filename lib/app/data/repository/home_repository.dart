import 'package:ucif/app/data/models/count_families_and_people.dart';
import 'package:ucif/app/data/models/genre_model.dart';
import 'package:ucif/app/data/provider/home_provider.dart';

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
}
