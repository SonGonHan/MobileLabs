import '../../entities/user.dart';

abstract class UserStorage {
  Future<User?> getByLogin(String login);
  Future<void> save(User user);
  Future<void> update(User oldUser, User updatedUser);
  Future<void> delete(String login);
  Future<List<User>> getAll();
}
