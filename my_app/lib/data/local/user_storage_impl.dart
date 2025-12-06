import 'package:sqflite/sqflite.dart';
import '../../domain/entities/user.dart';
import '../../domain/services/storage/user_storage.dart';
import 'database/app_database.dart';

class UserStorageImpl implements UserStorage {
  final AppDatabase appDb;

  UserStorageImpl(this.appDb);

  @override
  Future<User?> getByLogin(String login) async {
    final db = await appDb.database;
    final maps = await db.query(
      'users',
      where: 'login = ?',
      whereArgs: [login],
    );
    
    if (maps.isEmpty) return null;
    return _mapToUser(maps.first);
  }

  @override
  Future<void> save(User user) async {
    final db = await appDb.database;
    await db.insert(
      'users',
      _userToMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(User oldUser, User updatedUser) async {
    final db = await appDb.database;
    await db.update(
      'users',
      _userToMap(updatedUser),
      where: 'login = ?',
      whereArgs: [oldUser.login],
    );
  }

  @override
  Future<void> delete(String login) async {
    final db = await appDb.database;
    await db.delete(
      'users',
      where: 'login = ?',
      whereArgs: [login],
    );
  }

  @override
  Future<List<User>> getAll() async {
    final db = await appDb.database;
    final maps = await db.query('users');
    return maps.map((map) => _mapToUser(map)).toList();
  }

  Map<String, dynamic> _userToMap(User user) {
    return {
      'login': user.login,
      'password': user.password,
      'email': user.email,
      'phone': user.phone,
      'city': user.city,
      'street': user.street,
      'house': user.house,
    };
  }

  User _mapToUser(Map<String, dynamic> map) {
    return User(
      login: map['login'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      city: map['city'] as String,
      street: map['street'] as String,
      house: map['house'] as String,
    );
  }
}
