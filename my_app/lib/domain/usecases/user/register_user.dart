import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import 'user_result.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<UserResult> call({
    required String login,
    required String password,
    required String email,
    required String phone,
    required String city,
    required String street,
    required String house,
  }) async {
    final errors = <String>[];

    if (login.trim().isEmpty) {
      errors.add('Логин обязателен');
    }
    if (password.trim().isEmpty) {
      errors.add('Пароль обязателен');
    }
    if (email.trim().isEmpty) {
      errors.add('Email обязателен');
    }
    if (phone.trim().isEmpty) {
      errors.add('Телефон обязателен');
    }
    if (city.trim().isEmpty) {
      errors.add('Город обязателен');
    }
    if (street.trim().isEmpty) {
      errors.add('Улица обязательна');
    }
    if (house.trim().isEmpty) {
      errors.add('Дом обязателен');
    }


    if (errors.isNotEmpty) {
      return UserResult.failure(errors);
    }

    final existingUser = await repository.getByLogin(login);
    if (existingUser != null) {
      return UserResult.failure(
        ['Пользователь с таким логином уже существует'],
      );
    }

    final user = User(
      login: login,
      password: password,
      email: email,
      phone: phone,
      city: city,
      street: street,
      house: house,
    );

    await repository.saveUser(user);

    return UserResult.success(user);
  }
}
