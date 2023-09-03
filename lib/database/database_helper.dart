import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "db.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
    CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
    );
    ''');

    // Attractions table
    await db.execute('''
    CREATE TABLE attractions (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        imagePath TEXT NOT NULL
    );
    ''');

    // Bookings table
    await db.execute('''
    CREATE TABLE bookings (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        attraction_id INTEGER,
        booking_time TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(attraction_id) REFERENCES attractions(id)
    );
    ''');

    await _seedDatabase(db);
  }

  Future _seedDatabase(Database db) async {
    // Insert dummy data into users
    await db.insert('users', {
      'name': 'johndoe',
      'email': 'john.doe@example.com',
      'password': 'parola'
    });
    await db.insert('users', {
      'name': 'janedoe',
      'email': 'jane.doe@example.com',
      'password': 'parola'
    });

    // Insert dummy data into attractions
    await db.insert('attractions', {
      'name': 'Statue of Liberty',
      'description': 'An iconic symbol of freedom',
      'imagePath': 'banner_image.jpg'
    });
    await db.insert('attractions', {
      'name': 'Central Park',
      'description': 'An urban oasis in the middle of NYC',
      'imagePath': 'banner_image.jpg'
    });

    await db.insert('bookings', {
      'user_id': 1,
      'attraction_id': 1,
      'booking_time': '2023-09-03 10:00:00'
    });
    await db.insert('bookings', {
      'user_id': 2,
      'attraction_id': 2,
      'booking_time': '2023-09-04 15:30:00'
    });
  }

  Future<void> updateBookingTime(int bookingId, String newTime) async {
    final db = await database;

    await db.update(
      'bookings',
      {'booking_time': newTime},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future<void> deleteBooking(int bookingId) async {
    final db = await database;

    await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }
}
