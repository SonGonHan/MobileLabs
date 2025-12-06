import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  
  factory AppDatabase() {
    return _instance;
  }
  
  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bookstore.db');

    return openDatabase(
      path,
      version: 6,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE books (
        isbn TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        year TEXT,
        genre TEXT,
        price REAL NOT NULL,
        cachedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_books_title ON books(title)
    ''');

    await db.execute('''
      CREATE TABLE users (
        login TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        city TEXT NOT NULL,
        street TEXT NOT NULL,
        house TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userLogin TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        date INTEGER NOT NULL,
        status INTEGER NOT NULL
      ) 
    ''');


    await db.execute('''
      CREATE TABLE order_items (
        orderId TEXT NOT NULL,
        bookIsbn TEXT NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        PRIMARY KEY (orderId, bookIsbn),
        FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');

  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 5) {
    await db.execute('DROP TABLE IF EXISTS orders');
    await db.execute('DROP TABLE IF EXISTS order_items');
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userLogin TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        date INTEGER NOT NULL,
        status INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE order_items (
        orderId INTEGER NOT NULL,  // ← теперь INTEGER
        bookIsbn TEXT NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        PRIMARY KEY (orderId, bookIsbn),
        FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');
  }
  if (oldVersion < 6) {
    await db.execute('''
      CREATE TABLE books (
        isbn TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        year TEXT,
        genre TEXT,
        price REAL NOT NULL,
        cachedAt INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_books_title ON books(title)
    ''');
  }
}
}
