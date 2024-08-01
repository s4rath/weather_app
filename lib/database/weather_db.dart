import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WeatherDatabase {
  static final WeatherDatabase instance = WeatherDatabase._init();

  static Database? _database;

  WeatherDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('weather.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE weather (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  city TEXT,
  country TEXT,
  temperature REAL,
  feelsLike REAL,
  description TEXT,
  icon TEXT,
  humidity INTEGER
)
''');

    await db.execute('''
CREATE TABLE forecast (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dateTime TEXT,
  temperature REAL,
  description TEXT,
  icon TEXT,
  humidity INTEGER
)
''');
  }

  Future<int> insertWeather(Map<String, dynamic> weather) async {
    final db = await instance.database;
    return await db.insert('weather', weather);
  }

  Future<int> insertForecast(Map<String, dynamic> forecast) async {
    final db = await instance.database;
    return await db.insert('forecast', forecast);
  }

  Future<Map<String, dynamic>?> fetchWeather() async {
    final db = await instance.database;
    final maps = await db.query('weather');

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchForecast() async {
    final db = await instance.database;
    final maps = await db.query('forecast');

    return maps;
  }

  Future<int> deleteWeather() async {
    final db = await instance.database;
    return await db.delete('weather');
  }

  Future<int> deleteForecast() async {
    final db = await instance.database;
    return await db.delete('forecast');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
