import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/device.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'device_fault_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE devices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        fault TEXT,
        count INTEGER,
        notes TEXT,
        branchCode TEXT,
        branchName TEXT,
        branchType TEXT,
        registrationType TEXT
      )
      '''
    );
  }

  Future<int> insertDevice(Device device) async {
    Database db = await _instance.database;
    return await db.insert('devices', device.toMap());
  }

  Future<List<Device>> getDevicesByBranchCode(String branchCode) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'devices',
      where: 'branchCode = ?',
      whereArgs: [branchCode],
    );
    return List.generate(maps.length, (i) {
      return Device.fromMap(maps[i]);
    });
  }

  Future<int> deleteDevice(int id) async {
    Database db = await _instance.database;
    return await db.delete(
      'devices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateDevice(Device device) async {
    Database db = await _instance.database;
    return await db.update(
      'devices',
      device.toMap(),
      where: 'id = ?',
      whereArgs: [device.id],
    );
  }
}

