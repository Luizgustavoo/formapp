import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PeopleDatabaseHelper {
  static const String dbName = 'family_database.db';
  static const String peopleTableName = 'people';

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return openDatabase(path, version: 4, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $peopleTableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          foto TEXT,
          nome TEXT,
          cpf TEXT,
          estadoCivilId TEXT,
          parentesco TEXT,
          provedorCasa TEXT,
          sexo TEXT,
          dataNascimento TEXT,
          tituloEleitor TEXT,
          zonaEleitoral TEXT,
          celular TEXT,
          redeSocial TEXT,
          localTrabalho TEXT,
          cargoTrabalho TEXT,
          funcaoIgreja TEXT,
          status TEXT,
          usuarioId TEXT,
          familiaId TEXT,
          igrejaId TEXT,
        );
    ''');
  }

  Future<int> insertPeople(People people) async {
    final Database db = await getDatabase();
    return await db.insert(peopleTableName, people.toJson());
  }

  Future<List<People>> getAllPeople() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(peopleTableName);
    return List.generate(maps.length, (i) {
      return People.fromJson(maps[i]);
    });
  }
}
