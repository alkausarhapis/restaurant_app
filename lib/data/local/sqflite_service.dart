import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteService {
  static const String _dbName = 'favorite_restaurants.db';
  static const int _version = 1;
  static const String _tblRestaurants = 'restaurants';

  Database? _database;

  Future<Database> _initDb() async {
    if (_database != null) return _database!;
    final db = await openDatabase(
      _dbName,
      version: _version,
      onCreate: (db, int version) async => _createTables(db),
    );
    _database = db;
    return db;
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_tblRestaurants (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        city TEXT,
        pictureId TEXT,
        rating REAL,
        description TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  // Update/Insert minimal fields extracted from RestaurantDetail.
  Future<void> upsertFavorite(RestaurantDetail detail) async {
    final db = await _initDb();
    await db.insert(_tblRestaurants, {
      'id': detail.id,
      'name': detail.name,
      'city': detail.city,
      'pictureId': detail.pictureId,
      'rating': detail.rating,
      'description': detail.description,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Check if the restaurant is favorited.
  Future<bool> isFavorite(String id) async {
    final db = await _initDb();
    final rows = await db.query(
      _tblRestaurants,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  // Get list of favorite restaurants.
  Future<List<FavoriteRestaurant>> getAllFavorites() async {
    final db = await _initDb();
    final rows = await db.query(
      _tblRestaurants,
      orderBy: 'created_at DESC',
      columns: ['id', 'name', 'city', 'pictureId', 'rating', 'description'],
    );
    return rows.map((m) => FavoriteRestaurant.fromMap(m)).toList();
  }

  Future<int> removeFavorite(String id) async {
    final db = await _initDb();
    return db.delete(_tblRestaurants, where: 'id = ?', whereArgs: [id]);
  }
}
