import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/people_model.dart';

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
          estadocivil_id INTEGER,
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
          usuario_id INTEGER,
          igreja_id TEXT,
          religiao_id INTEGER,
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

  Future<int> updateFamily(Family family) async {
    final db = await database;
    return await db.update(
      'families',
      family.toMap(),
      where: 'id = ?',
      whereArgs: [family.id],
    );
  }

  Future<int> insertPeople(People people) async {
    final db = await database;
    return await db.insert('people', people.toMap());
  }

  Future<int> updatePeople(People people) async {
    final db = await database;
    return await db.update(
      'people',
      people.toMap(),
      where: 'id = ?',
      whereArgs: [people.id],
    );
  }

  Future<int> deleteFamilyAndPeople(int familyId) async {
    int delete = 0;
    final db = await database;
    delete += await db.delete('people',
        where: 'familia_id = ? and id > 0', whereArgs: [familyId]);
    delete +=
        await db.delete('families', where: 'id = ?', whereArgs: [familyId]);
    return delete;
  }

  Future<List<Map<String, dynamic>>> getFamiliesOffline() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
      families.id AS id_familia,
      families.nome AS nome_familia,
      families.endereco AS endereco_familia,
      families.numero_casa AS numero_casa_familia,
      families.bairro AS bairro_familia,
      families.cidade AS cidade_familia,
      families.uf AS uf_familia,
      families.complemento AS complemento_familia,
      families.residencia_propria AS residencia_propria_familia,
      families.usuario_id AS usuario_id_familia,
      families.status AS status_familia,
      families.data_cadastro AS data_cadastro_familia,
      families.data_update AS data_update_familia,
      families.cep AS cep_familia
      FROM families
    ''');
  }

  Future<List<Map<String, dynamic>>> getPeoplesOffline() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
      people.id AS id_people,
      people.nome AS nome_people,
      people.foto AS foto_people,
      people.sexo AS sexo_people,
      people.cpf AS cpf_people,
      people.data_nascimento AS data_nascimento_people,
      people.estadocivil_id AS estadocivil_id_people,
      people.titulo_eleitor AS titulo_eleitor_people,
      people.zona_eleitoral AS zona_eleitoral_people,
      people.telefone AS telefone_people,
      people.rede_social AS rede_social_people,
      people.provedor_casa AS provedor_casa_people,
      people.igreja_id AS igreja_id_people,
      people.local_trabalho AS local_trabalho_people,
      people.cargo_trabalho AS cargo_trabalho_people,
      people.religiao_id AS religiao_id_people,
      people.funcao_igreja AS funcao_igreja_people,
      people.usuario_id AS usuario_id_people,
      people.status AS status_people,
      people.data_cadastro AS data_cadastro_people,
      people.data_update AS data_update_people,
      people.familia_id AS familia_id_people,
      people.parentesco AS parentesco_people
      FROM people
    ''');
  }
}
