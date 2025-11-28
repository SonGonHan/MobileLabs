import 'user_result.dart';
import '../../repositories/user_repository.dart';

class AuthenticateUser {
  final UserRepository repository;

  AuthenticateUser(this.repository);

  Future<UserResult> call({ 
    required String login, 
    required String password
  }
  ) async {
    final errors = <String>[];

    if (login.trim().isEmpty) {
      errors.add('Логин обязателен');
    }
    if (password.trim().isEmpty) {
      errors.add('Пароль обязателен');
    }

    if (errors.isNotEmpty) {
      return UserResult.failure(errors);
    }

    final user = await repository.getByLogin(login);
    if (user != null) {  
      final isCorrect = await repository.authenticateUser(login, password);
      if (isCorrect) {
        return UserResult.success(user);
      }
    }
    return UserResult.failure(['Некорректный логин или пароль'],);
    } 
}