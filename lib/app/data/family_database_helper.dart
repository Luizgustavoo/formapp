import 'package:formapp/app/data/models/family_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FamilyDatabaseHelper {
  static const String dbName = 'family_database.db';
  static const String familiaTableName = 'family';

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $familiaTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        endereco TEXT,
        numero_casa TEXT,
        bairro TEXT,
        cidade TEXT,
        uf TEXT,
        complemento TEXT,
        residencia_propria TEXT,
        usuario_id INTEGER,
        status INTEGER,
        cep TEXT,
        data_cadastro TEXT,
        data_update TEXT
      )
    ''');
  }

  Future<int> insertFamily(Family familia) async {
    final Database db = await getDatabase();
    return await db.insert(familiaTableName, familia.toJson());
  }

  Future<List<Family>> getAllFamily() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(familiaTableName);
    return List.generate(maps.length, (i) {
      return Family.fromJson(maps[i]);
    });
  }
}
