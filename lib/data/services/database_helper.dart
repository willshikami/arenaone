import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:arenaone/data/models/team.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'arena_one.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE followed_teams(
        id TEXT PRIMARY KEY,
        name TEXT,
        sport TEXT,
        logoUrl TEXT,
        isFollowing INTEGER
      )
    ''');
    
    await db.execute('''
      CREATE TABLE user_preferences(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // Generic key-value persistence
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return null;
  }

  // Example: Persisting a Team using json_serializable mapping
  Future<void> saveTeam(Team team) async {
    final db = await database;
    final Map<String, dynamic> data = team.toJson();
    // Convert bool to int for SQLite
    data['isFollowing'] = team.isFollowing ? 1 : 0;
    
    await db.insert(
      'followed_teams',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Team>> getFollowedTeams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('followed_teams');
    
    return List.generate(maps.length, (i) {
      final json = Map<String, dynamic>.from(maps[i]);
      // Convert int back to bool for model
      json['isFollowing'] = json['isFollowing'] == 1;
      return Team.fromJson(json);
    });
  }
}
