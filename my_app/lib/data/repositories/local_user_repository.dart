import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/services/storage/user_storage.dart';

class LocalUserRepository implements UserRepository {
  final UserStorage userStorage;

  LocalUserRepository(this.userStorage);

  @override
  Future<bool> authenticateUser(String login, String password) async {
    final user = await userStorage.getByLogin(login);
    return user != null && user.password == password;
  }

  @override
  Future<User?> getByLogin(String login) async {
    return await userStorage.getByLogin(login);
  }

  @override
  Future<void> saveUser(User user) async {
    await userStorage.save(user);
  }

  @override
  Future<void> updateUser(User oldUser, User updatedUser) async {
    await userStorage.update(oldUser, updatedUser);
  }
}
