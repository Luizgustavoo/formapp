import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String dbName = 'family_database.db';
  //static const String tableName = 'family_table';

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE family_table(
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
      );

      CREATE TABLE people_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        cpf TEXT,
        estadoCivilId INTEGER,
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
        status INTEGER,
        usuarioId INTEGER,
        familiaId INTEGER,
        igrejaId TEXT,
        foto TEXT
      );

      CREATE TABLE family_service_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_atendimento TEXT,
        assunto TEXT,
        descricao TEXT,
        usuario_id INTEGER,
        data_cadastro TEXT,
        data_update TEXT,
        pessoa_id INTEGER
      );

       CREATE TABLE message_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT,
        titulo TEXT,
        descricao TEXT,
        usuario_id INTEGER,
        data_cadastro TEXT,
        data_update TEXT
      )
    ''');
  }

  Future<dynamic> insert(Map<String, dynamic> data, String tableName) async {
    final Database db = await getDatabase();
    var response = await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return response;
  }

  Future<void> update(
      int id, Map<String, dynamic> data, String tableName) async {
    final Database db = await getDatabase();
    await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllDataLocal(String tableName) async {
    final Database db = await getDatabase();
    return await db.query(tableName);
  }

  Future<void> delete(int id, String? tableName) async {
    final Database db = await getDatabase();
    await db.delete(
      tableName!,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
