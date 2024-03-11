import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'credenciado.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE families(
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
        data_cadastro  TEXT,
        data_update    TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE people(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          foto TEXT,
          nome TEXT,
          cpf TEXT,
          estadocivil_id TEXT,
          parentesco TEXT,
          provedor_casa TEXT,
          sexo TEXT,
          data_nascimento TEXT,
          titulo_eleitor TEXT,
          zona_eleitoral TEXT,
          telefone TEXT,
          rede_social TEXT,
          local_trabalho TEXT,
          cargo_trabalho TEXT,
          funcao_igreja TEXT,
          status TEXT,
          usuario_id TEXT,
          igreja_id TEXT,
          religiao_id TEXT,
          familia_id INTEGER,
          data_cadastro TEXT,
          data_update TEXT
      )
    ''');
  }

  Future<int> insertFamily(Family family) async {
    final db = await database;
    return await db.insert('families', family.toMap());
  }

  Future<int> insertPeople(People people) async {
    final db = await database;
    return await db.insert('people', people.toMap());
  }

  Future<List<Map<String, dynamic>>> getFamiliesWithPeople() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT families.id AS family_id, families.nome AS family_nome,
             people.id AS people_id, people.nome AS people_nome
      FROM families
      LEFT JOIN people ON families.id = people.family_id
    ''');
  }
}
