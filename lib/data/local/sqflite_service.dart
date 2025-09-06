import 'package:restaurant_app/data/model/detail/restaurant_detail.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteService {
  static const String _dbName = 'favorite_restaurants.db';
  static const int _version = 1;

  static const String _tblRestaurants = 'restaurants';
  static const String _tblCategories = 'categories';
  static const String _tblMenuItems = 'menu_items';
  static const String _tblReviews = 'customer_reviews';

  Database? _database;

  Future<Database> _initDb() async {
    if (_database != null) return _database!;
    final database = await openDatabase(
      _dbName,
      version: _version,
      onConfigure: (Database database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database database, int version) async =>
          _createTables(database),
    );
    _database = database;
    return database;
  }

  Future<void> _createTables(Database database) async {
    await database.execute('''
      CREATE TABLE $_tblRestaurants (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        city TEXT,
        address TEXT,
        pictureId TEXT,
        rating REAL,
        created_at INTEGER NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE $_tblCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id TEXT NOT NULL,
        name TEXT NOT NULL,
        UNIQUE(restaurant_id, name),
        FOREIGN KEY (restaurant_id) REFERENCES $_tblRestaurants(id) ON DELETE CASCADE
      )
    ''');

    await database.execute('''
      CREATE TABLE $_tblMenuItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('food','drink')),
        UNIQUE(restaurant_id, name, type),
        FOREIGN KEY (restaurant_id) REFERENCES $_tblRestaurants(id) ON DELETE CASCADE
      )
    ''');

    // (fixed) This was duplicated before; it should be the reviews table.
    await database.execute('''
      CREATE TABLE $_tblReviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id TEXT NOT NULL,
        customer_name TEXT,
        review TEXT,
        review_date TEXT,
        FOREIGN KEY (restaurant_id) REFERENCES $_tblRestaurants(id) ON DELETE CASCADE
      )
    ''');

    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_cat_rest ON $_tblCategories(restaurant_id)',
    );
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_menu_rest ON $_tblMenuItems(restaurant_id)',
    );
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_rev_rest  ON $_tblReviews(restaurant_id)',
    );
  }

  // Insert/update favorite data in a single transaction, replacing old rows if the ID already exists.
  Future<void> upsertFavorite(RestaurantDetail detail) async {
    final database = await _initDb();
    final restaurantJson = detail.toJson();

    await database.transaction((Transaction transaction) async {
      await transaction.insert(_tblRestaurants, {
        'id': restaurantJson['id'],
        'name': restaurantJson['name'],
        'description': restaurantJson['description'],
        'city': restaurantJson['city'],
        'address': restaurantJson['address'],
        'pictureId': restaurantJson['pictureId'],
        'rating': restaurantJson['rating'],
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      final String restaurantId = restaurantJson['id'] as String;

      // Clear existing child rows to keep local data in sync with the API.
      await transaction.delete(
        _tblCategories,
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
      );
      await transaction.delete(
        _tblMenuItems,
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
      );
      await transaction.delete(
        _tblReviews,
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
      );

      // Insert categories.
      final List<Map<String, dynamic>> categoryList =
          (restaurantJson['categories'] as List).cast<Map<String, dynamic>>();
      for (final category in categoryList) {
        await transaction.insert(_tblCategories, {
          'restaurant_id': restaurantId,
          'name': category['name'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      // Insert menu items.
      final Map<String, dynamic> menusJson =
          (restaurantJson['menus'] as Map<String, dynamic>);
      final List<Map<String, dynamic>> foodsList = (menusJson['foods'] as List)
          .cast<Map<String, dynamic>>();
      final List<Map<String, dynamic>> drinksList =
          (menusJson['drinks'] as List).cast<Map<String, dynamic>>();

      for (final food in foodsList) {
        await transaction.insert(_tblMenuItems, {
          'restaurant_id': restaurantId,
          'name': food['name'],
          'type': 'food',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      for (final drink in drinksList) {
        await transaction.insert(_tblMenuItems, {
          'restaurant_id': restaurantId,
          'name': drink['name'],
          'type': 'drink',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      // Insert customer reviews.
      final List<Map<String, dynamic>> reviewList =
          (restaurantJson['customerReviews'] as List)
              .cast<Map<String, dynamic>>();
      for (final review in reviewList) {
        await transaction.insert(_tblReviews, {
          'restaurant_id': restaurantId,
          'customer_name': review['name'],
          'review': review['review'],
          'review_date': review['date'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    });
  }

  // Check if a restaurant is favorited (existence check only).
  Future<bool> isFavorite(String id) async {
    final database = await _initDb();
    final rows = await database.query(
      _tblRestaurants,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  // Get favorite restaurant list.
  Future<List<Map<String, dynamic>>> favoriteRestaurantList() async {
    final database = await _initDb();
    return database.query(
      _tblRestaurants,
      columns: ['id', 'name', 'city', 'pictureId', 'rating', 'description'],
      orderBy: 'name ASC',
    );
  }

  // Get a full favorited restaurant with categories, menu items, and reviews.
  Future<RestaurantDetail?> getDetailRelationId(String id) async {
    final database = await _initDb();

    final restaurantRows = await database.query(
      _tblRestaurants,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (restaurantRows.isEmpty) return null;

    final categoryRows = await database.query(
      _tblCategories,
      where: 'restaurant_id = ?',
      whereArgs: [id],
    );
    final menuItemRows = await database.query(
      _tblMenuItems,
      where: 'restaurant_id = ?',
      whereArgs: [id],
    );
    final reviewRows = await database.query(
      _tblReviews,
      where: 'restaurant_id = ?',
      whereArgs: [id],
      orderBy: 'id DESC',
    );

    final assembledJson = _assembleDetailJson(
      restaurantRows.first,
      categoryRows,
      menuItemRows,
      reviewRows,
    );
    return RestaurantDetail.fromJson(assembledJson);
  }

  // Get all favorited restaurants (fully assembled).
  Future<List<RestaurantDetail>> getTableFavoriteRestaurant() async {
    final database = await _initDb();
    final restaurantRows = await database.query(
      _tblRestaurants,
      orderBy: 'name ASC',
    );

    final List<RestaurantDetail> results = [];
    for (final restaurantRow in restaurantRows) {
      final String restaurantId = restaurantRow['id'] as String;

      final categoryRows = await database.query(
        _tblCategories,
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
      );
      final menuItemRows = await database.query(
        _tblMenuItems,
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
      );
      final reviewRows = await database.query(
        _tblReviews,
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
        orderBy: 'id DESC',
      );

      final assembledJson = _assembleDetailJson(
        restaurantRow,
        categoryRows,
        menuItemRows,
        reviewRows,
      );
      results.add(RestaurantDetail.fromJson(assembledJson));
    }
    return results;
  }

  // Remove a restaurant from favorites (children are deleted via CASCADE).
  Future<int> removeFavorite(String id) async {
    final database = await _initDb();
    return database.delete(_tblRestaurants, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final database = await _initDb();
    await database.transaction((Transaction transaction) async {
      await transaction.delete(_tblReviews);
      await transaction.delete(_tblMenuItems);
      await transaction.delete(_tblCategories);
      await transaction.delete(_tblRestaurants);
    });
  }

  // Assemble a JSON compatible with RestaurantDetail.fromJson
  Map<String, dynamic> _assembleDetailJson(
    Map<String, Object?> restaurantRow,
    List<Map<String, Object?>> categoryRows,
    List<Map<String, Object?>> menuItemRows,
    List<Map<String, Object?>> reviewRows,
  ) {
    final List<Map<String, Object?>> foods = menuItemRows
        .where((menuItem) => menuItem['type'] == 'food')
        .map((menuItem) => {'name': menuItem['name']})
        .toList();

    final List<Map<String, Object?>> drinks = menuItemRows
        .where((menuItem) => menuItem['type'] == 'drink')
        .map((menuItem) => {'name': menuItem['name']})
        .toList();

    return {
      'id': restaurantRow['id'],
      'name': restaurantRow['name'],
      'description': restaurantRow['description'],
      'city': restaurantRow['city'],
      'address': restaurantRow['address'],
      'pictureId': restaurantRow['pictureId'],
      'rating': (restaurantRow['rating'] as num?)?.toDouble() ?? 0.0,
      'categories': categoryRows
          .map((category) => {'name': category['name']})
          .toList(),
      'menus': {'foods': foods, 'drinks': drinks},
      'customerReviews': reviewRows
          .map(
            (review) => {
              'name': review['customer_name'],
              'review': review['review'],
              'date': review['review_date'],
            },
          )
          .toList(),
    };
  }
}
