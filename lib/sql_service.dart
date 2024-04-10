import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;

class DatabaseHelper{
  int id = 0;
  final String _tableName = "Notes";
  sql.Database? _database;

  DatabaseHelper(){
    initialise;
  }

  Future<void> get initialise async {
    if(_database != null){
      _database = _database;
      return;
    }
    String dbPath = await sql.getDatabasesPath();
    String path = p.join(dbPath,_tableName);
    _database = await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await initialiseTables(db),
    );
  }

  Future<void> get getLength async {
    List<Map<String, Object?>>? data = await _database?.rawQuery('''SELECT * FROM $_tableName;''');
    id = data?.length ?? 0;
  }

  Future<void> initialiseTables(sql.Database database) async {
    database.rawQuery('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY NOT NULL,
        text STRING NOT NULL
      );
    ''');
  }

  Future<List<Map<String, Object?>>?> get getData async {
    await initialise;
    await getLength;
    var data = await _database?.rawQuery('''
      SELECT * FROM $_tableName;
    ''');
    return data;
  }

  Future<Map<String, Object?>?> getDataAt(int id) async {
    await initialise;
    var data = await _database!.rawQuery(
      '''
        SELECT * FROM $_tableName WHERE id=?
      ''',
      [id]
    );
    if (data.length == 1) return data[0];
    return null;
  }

  Future<bool> insertData(int id, String text) async {
    await initialise;
    int? result = await _database?.insert(
      _tableName,
      {
        'id' : id,
        'text' : text,
      },
    );
    if(result != id) return false;
    return true;
  }

  Future<bool> updateData(int id, String text) async {
    await initialise;
    int? result = await _database!.rawUpdate(
      '''
        UPDATE $_tableName SET text = ? WHERE id = ?
      ''',
      [text, id]
    );
    if (result != 1) return false;
    return true;
  }

  Future<bool> deleteData(int id) async {
    await initialise;
    int? result = await _database?.delete(
      _tableName,
      where: 'id == $id',
    );
    if(result != 1) return false;
    List<Map<String,Object?>>? data = await getData;
    await _database?.delete(_tableName);
    for(int i = 0; i < this.id; i++){
      await insertData(i, data?[i]['text'] as String);
    }
    return true;
  }
}