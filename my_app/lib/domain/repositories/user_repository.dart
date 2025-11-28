import '../entities/user.dart';

abstract class UserRepository {
  Future<bool> authenticateUser(String login, String password);
  Future<User?> getByLogin(String login);
  Future<void> saveUser(User user);
  Future<void> updateUser(User oldUser, User updatedUser);
}