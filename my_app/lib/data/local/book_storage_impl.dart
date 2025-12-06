import 'package:sqflite/sqflite.dart';

import 'database/app_database.dart';

import '../../domain/entities/book.dart';
import '../../domain/services/storage/book_storage.dart';

class BookStorageImpl implements BookStorage {
  final AppDatabase appDb;

  BookStorageImpl(this.appDb);

  @override
  Future<void> save(List<Book> books) async {
    final db = await appDb.database;
    final batch = db.batch();

    for (final book in books) {
      batch.insert(
        'books',
        _bookToMap(book),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  @override
  Future<List<Book>> getAll() async {
    final db = await appDb.database;
    final maps = await db.query(
      'books',
      orderBy: 'cachedAt DESC',
    );
    return maps.map(_mapToBook).toList();
  }

  @override
  Future<List<Book>> search(String query) async {
    final db = await appDb.database;
    final q = '%$query%';
    final maps = await db.query(
      'books',
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: [q, q],
      orderBy: 'cachedAt DESC',
    );
    return maps.map(_mapToBook).toList();
  }

  @override
  Future<Book?> getByIsbn(String isbn) async {
    final db = await appDb.database;
    final maps = await db.query(
      'books',
      where: 'isbn = ?',
      whereArgs: [isbn],
    );
    if (maps.isEmpty) return null;
    return _mapToBook(maps.first);
  }

  @override
  Future<void> clear() async {
    final db = await appDb.database;
    await db.delete('books');
  }

  @override
  Future<List<Book>> getBooksPage(int limit,int offset) async {
    final db = await appDb.database;
    final maps = await db.query(
      'books',
      orderBy: 'cachedAt DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map(_mapToBook).toList();
  }


  Map<String, dynamic> _bookToMap(Book book) {
    return {
      'isbn': book.isbn,
      'title': book.title,
      'author': book.author,
      'year': book.year,
      'genre': book.genre,
      'price': book.price,
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Book _mapToBook(Map<String, dynamic> map) {
    return Book(
      title: map['title'] as String,
      author: map['author'] as String,
      year: map['year'] as String? ?? '—',
      genre: map['genre'] as String? ?? 'Не указан',
      isbn: map['isbn'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }
}
