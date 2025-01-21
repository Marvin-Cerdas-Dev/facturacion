import 'package:facturacion/data/measurement_units.dart';
import 'package:facturacion/data/municipality.dart';
import 'package:facturacion/data/numbering_range.dart';
import 'package:facturacion/data/token.dart';
import 'package:facturacion/data/tributes.dart';
import 'package:sqflite/sqflite.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late Database _db;
  final String dbName = 'storage.db';

  StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  Future<void> _ensureInitialized() async {
    // ignore: unnecessary_null_comparison
    if (_db == null) {
      await init();
    }
  }

  Future<void> deleteDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = path + dbName;
    await databaseFactory.deleteDatabase(dbPath);
    //print('Base de datos eliminada');
  }

  Future<void> init({bool isDev = true}) async {
    try {
      if (isDev) {
        await deleteDatabase();
      }

      final path = await getDatabasesPath();
      final dbPath = path + dbName;

      _db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
          //print('Creando tablas de la base de datos...');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS Token (
              id_key INTEGER PRIMARY KEY,
              dateTime TEXT NOT NULL,
              token_type TEXT NOT NULL,
              expires_in INTEGER NOT NULL,
              access_token TEXT NOT NULL,
              refresh_token TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS NumberRange (
              id_key INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER NOT NULL,
              document TEXT NOT NULL,
              prefix TEXT NOT NULL,
              "from" INTEGER NOT NULL,
              "to" INTEGER NOT NULL,
              current INTEGER NOT NULL,
              resolution_number TEXT,
              start_date TEXT NOT NULL,
              end_Date TEXT NOT NULL,
              technical_key TEXT,
              is_expired INTEGER NOT NULL,
              is_active INTEGER NOT NULL,
              created_at TEXT NOT NULL,
              updated_at TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS Municipalities (
              id_key INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER NOT NULL,
              code TEXT NOT NULL,
              name TEXT NOT NULL,
              department TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS Tributes (
              id_key INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER NOT NULL,
              code TEXT NOT NULL,
              name TEXT NOT NULL,
              description TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS MeasurementUnits (
              id_key INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER NOT NULL,
              code TEXT NOT NULL,
              name TEXT NOT NULL
            )
          ''');

          //print('Tablas creadas exitosamente');
        },
        onOpen: (db) {
          //print('Base de datos abierta exitosamente');
        },
      );
    } catch (e) {
      //print('Error al inicializar la base de datos: $e');
      rethrow;
    }
  }

  // Token Methods
  Future<void> insertToken(Token data) async {
    await _ensureInitialized();
    try {
      await _db.insert('Token', data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      //print('Token guardado');
    } catch (e) {
      //print('Error al insertar token: $e');
      rethrow;
    }
  }

  Future<Token> getToken() async {
    await _ensureInitialized();
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('Token', where: 'id_key = 1');
      //print('Token recuperado');
      return maps.map((map) => Token.fromJson(map)).first;
    } catch (e) {
      //print('Error al obtener el token: $e');
      rethrow;
    }
  }

  Future<int> updateToken(Token data) async {
    await _ensureInitialized();
    //print('Token actualizado');
    return await _db.update('Token', data.toMap(), where: 'id_key = 1');
  }

  // NumberRange Methods
  Future<void> insertNumberRange(NumberRange data) async {
    await _ensureInitialized();
    await _db.insert('NumberRange', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NumberRange>> getAllNumberRange() async {
    _ensureInitialized();
    final List<Map<String, dynamic>> maps = await _db.query('NumberRange');
    return maps.map((map) => NumberRange.fromJson(map)).toList();
  }

  Future<NumberRange> getIdNumberRange(int id) async {
    await _ensureInitialized();
    final List<Map<String, dynamic>> maps =
        await _db.query('NumberRange', where: 'id_key = ?', whereArgs: [id]);
    return maps.map((map) => NumberRange.fromJson(map)).first;
  }

  Future<void> deleteNumberRange(int id) async {
    await _ensureInitialized();
    await _db.delete('NumberRange', where: 'id_key = ?', whereArgs: [id]);
  }

  Future<int> updateNumberRange(NumberRange data) async {
    await _ensureInitialized();
    return await _db.update('NumberRange', data.toMap(),
        where: 'id_key = ?', whereArgs: [data.id]);
  }

  // Municipalities Methods
  Future<void> insertMunicipality(Municipality data) async {
    await _ensureInitialized();
    await _db.insert('Municipalities', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Municipality>> getAllMunicipalities() async {
    _ensureInitialized();
    final List<Map<String, dynamic>> maps = await _db.query('Municipalities');
    return maps.map((map) => Municipality.fromJson(map)).toList();
  }

  // Tributes Methods
  Future<void> insertTribute(Tribute data) async {
    await _ensureInitialized();
    await _db.insert('Tributes', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tribute>> getAllTributes() async {
    _ensureInitialized();
    final List<Map<String, dynamic>> maps = await _db.query('Tributes');
    return maps.map((map) => Tribute.fromJson(map)).toList();
  }

  // MeasurementUnits Methods
  Future<void> insertMeasurementUnits(MeasurementUnit data) async {
    await _ensureInitialized();
    await _db.insert('MeasurementUnits', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MeasurementUnit>> getAllMeasurementUnits() async {
    _ensureInitialized();
    final List<Map<String, dynamic>> maps = await _db.query('MeasurementUnits');
    return maps.map((map) => MeasurementUnit.fromJson(map)).toList();
  }
}
