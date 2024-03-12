import 'package:get_storage/get_storage.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';

class LocalStorageService {
  static final _familiaBox = GetStorage('families');

  // Método estático para salvar uma família localmente
  static Future<int> saveFamilyLocally(Family family) async {
    family.id ??= _generateUniqueId();
    await _familiaBox.write('family_${family.id}', family.toJson());
    return int.parse('${family.id}');
  }

  // Método estático para salvar uma pessoa localmente
  static Future<int> savePeopleLocally(People people) async {
    people.id ??= _generateUniqueId();
    await _familiaBox.write('people_${people.id}', people.toJson());
    print(people.toJson());
    return int.parse('${people.id}');
  }

  static int _generateUniqueId() {
    // Implemente sua lógica para gerar um ID único aqui, por exemplo, usando a data e hora atual
    return DateTime.now().millisecondsSinceEpoch;
  }

  // static List<Family> getFamiliesLocally() {
  //   List<Family> families = [];
  //   _familiaBox.getKeys().forEach((key) {
  //     if (key.startsWith('family_')) {
  //       var familyJson = _familiaBox.read(key);
  //       if (familyJson != null) {
  //         var family = Family.fromJson(familyJson);
  //         families.add(family);
  //       }
  //     }
  //   });

  //   print(families.first.nome);
  //   return families;
  // }

  static List<Family> getFamiliesLocally() {
    List<Family> families = [];
    _familiaBox.getKeys().forEach((key) {
      if (key.startsWith('family_')) {
        var familyJson = _familiaBox.read(key);
        if (familyJson != null) {
          var family = Family.fromJson(familyJson);
          family.pessoas = _getPeopleForFamily(family.id);
          families.add(family);
        }
      }
    });

    return families;
  }

  static List<People>? _getPeopleForFamily(int? familyId) {
    print(familyId);
    if (familyId == null) return null;

    List<People> peopleList = [];
    _familiaBox.getKeys().forEach((key) {
      if (key.startsWith('people_') && key.contains('_$familyId')) {
        var peopleJson = _familiaBox.read(key);
        if (peopleJson != null) {
          var people = People.fromJson(peopleJson);
          peopleList.add(people);
        }
      }
    });
    return peopleList.isNotEmpty ? peopleList : null;
  }
}
