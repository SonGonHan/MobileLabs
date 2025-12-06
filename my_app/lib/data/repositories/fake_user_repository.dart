import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class FakeUserRepository implements UserRepository {
  final List<User> _users = [
    User(
      login: 'demo',
      password: '123',
      email: 'demo@example.com',
      phone: '+7 900 000-00-00',
      city: 'Москва',
      street: 'Тверская',
      house: '1',
    ),
  ];

  @override
  Future<User?> getByLogin(String login) async {
    try {
      return _users.firstWhere(
        (u) => u.login == login,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    _users.add(user);
  }
  
  @override
  Future<bool> authenticateUser(String login, String password) async {
    return _users.any(
      (u) => u.login == login && u.password == password,
    );
  }

  @override
  Future<void> updateUser(User oldUser, User updatedUser) async {
    _users.remove(oldUser);
    _users.add(updatedUser);
  }
}
