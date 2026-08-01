import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/food_item.dart';
import '../models/weight_entry.dart';
import '../models/meal_log.dart';
import '../models/user_profile.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calorie_tracker.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createTables,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
      CREATE TABLE IF NOT EXISTS weight_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        weight_kg REAL NOT NULL,
        recorded_at TEXT NOT NULL
      )
    ''');
        }
      },
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // ─────────────────────────────────────────────
    // Food Items
    // ─────────────────────────────────────────────
    await db.execute('''
CREATE TABLE food_items (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  name_hindi TEXT,
  aliases TEXT,
  brand TEXT,
  category TEXT NOT NULL,

  serving_size REAL NOT NULL,
  serving_unit TEXT NOT NULL,

  calories REAL NOT NULL,
  protein REAL NOT NULL,
  carbs REAL NOT NULL,
  fat REAL NOT NULL,
  fiber REAL DEFAULT 0,
  sugar REAL DEFAULT 0,

  is_verified INTEGER DEFAULT 1,
  source TEXT
)
''');

    // ─────────────────────────────────────────────
    // Meal Logs
    // ─────────────────────────────────────────────
    await db.execute('''
CREATE TABLE meal_logs (
  id TEXT PRIMARY KEY,

  user_id TEXT NOT NULL,

  meal_type TEXT NOT NULL,
  meal_source TEXT NOT NULL,

  food_entries TEXT NOT NULL,

  original_prompt TEXT,
  ai_insight TEXT,

  logged_at TEXT NOT NULL,

  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');

    // ─────────────────────────────────────────────
    // User Profile
    // ─────────────────────────────────────────────
    await db.execute('''
CREATE TABLE user_profile (
  uid TEXT PRIMARY KEY,

  name TEXT NOT NULL,
  email TEXT NOT NULL,
  photo_url TEXT,

  gender TEXT NOT NULL,

  weight_kg REAL NOT NULL,
  height_cm REAL NOT NULL,
  age INTEGER NOT NULL,

  goal TEXT NOT NULL,
  activity_level TEXT NOT NULL,

  daily_calorie_goal REAL NOT NULL,
  daily_protein_goal REAL NOT NULL,
  daily_carbs_goal REAL NOT NULL,
  daily_fat_goal REAL NOT NULL
)
''');

    // ─────────────────────────────────────────────
    // Weight History
    // ─────────────────────────────────────────────

    await db.execute('''
CREATE TABLE weight_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  user_id TEXT NOT NULL,

  weight_kg REAL NOT NULL,

  recorded_at TEXT NOT NULL
)
''');
  }

  // ─────────────────────────────────────────────
  // Food Items
  // ─────────────────────────────────────────────

  Future<List<FoodItem>> searchFoods(String query) async {
    final db = await database;

    final results = await db.query(
      'food_items',
      where: 'name LIKE ? OR name_hindi LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      limit: 20,
    );

    return results.map((map) => FoodItem.fromMap(map)).toList();
  }

  Future<FoodItem?> getFoodByName(String name) async {
    final db = await database;

    final results = await db.query(
      'food_items',
      where: 'LOWER(name) = ? OR LOWER(name_hindi) = ?',
      whereArgs: [name.toLowerCase(), name.toLowerCase()],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return FoodItem.fromMap(results.first);
  }

  Future<List<FoodItem>> getFoodsByCategory(String category) async {
    final db = await database;

    final results = await db.query(
      'food_items',
      where: 'category = ?',
      whereArgs: [category],
    );

    return results.map((map) => FoodItem.fromMap(map)).toList();
  }

  // ─────────────────────────────────────────────
  // Meal Logs
  // ─────────────────────────────────────────────

  Future<void> saveMeal(MealLog log) async {
    final db = await database;

    await db.insert(
      'meal_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MealLog>> getMealsForDate(String userId, DateTime date) async {
    final db = await database;

    final startOfDay = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();

    final endOfDay = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
    ).toIso8601String();

    final results = await db.query(
      'meal_logs',
      where: 'user_id = ? AND logged_at BETWEEN ? AND ?',
      whereArgs: [userId, startOfDay, endOfDay],
      orderBy: 'logged_at ASC',
    );

    return results.map((map) => MealLog.fromMap(map)).toList();
  }

  Future<void> deleteMeal(String id) async {
    final db = await database;

    await db.delete('meal_logs', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────────
  // User Profile
  // ─────────────────────────────────────────────

  Future<void> saveUser(UserProfile profile) async {
    final db = await database;

    await db.insert(
      'user_profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfile?> getUser(String uid) async {
    final db = await database;

    final results = await db.query(
      'user_profile',
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return UserProfile.fromMap(results.first);
  }

  Future<void> insertWeightEntry(WeightEntry entry) async {
    final db = await database;

    await db.insert(
      'weight_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WeightEntry>> getWeightEntries(String userId) async {
    final db = await database;

    final results = await db.query(
      'weight_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
    );

    return results.map(WeightEntry.fromMap).toList();
  }

  Future<WeightEntry?> getLatestWeightEntry(String userId) async {
    final db = await database;

    final results = await db.query(
      'weight_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
      limit: 1,
    );

    if (results.isEmpty) return null;

    return WeightEntry.fromMap(results.first);
  }

  Future<void> deleteWeightEntry(int id) async {
    final db = await database;

    await db.delete('weight_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> logWeight({
    required String userId,
    required double weightKg,
  }) async {
    await insertWeightEntry(
      WeightEntry(
        userId: userId,
        weightKg: weightKg,
        recordedAt: DateTime.now(),
      ),
    );
  }
}
