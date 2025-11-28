import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import 'user_result.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<UserResult> call({
    required User oldUser,
    required String oldPassword,
    required String newPassword,
    required String email,
    required String phone,
    required String city,
    required String street,
    required String house,
  }) async {
    User updatedUser = User(
      login: oldUser.login,
      password: oldUser.password,
      email: oldUser.email,
      phone: oldUser.phone,
      city: oldUser.city,
      street: oldUser.city,
      house: oldUser.house,
    );

    if (newPassword.trim().isNotEmpty) {  
      if (oldPassword.trim().isNotEmpty && oldUser.password == oldPassword) {
        updatedUser.password = newPassword.trim();
      } else {
        return UserResult.failure(['Неверный старый пароль']);
      }
    }
    if (email.trim().isNotEmpty) {
      updatedUser.email = email.trim();
    }
    if (phone.trim().isNotEmpty) {
      updatedUser.phone = phone.trim();
    }
    if (city.trim().isNotEmpty) {
      updatedUser.city = city.trim();
    }
    if (street.trim().isNotEmpty) {
      updatedUser.street = street.trim();
    }
    if (house.trim().isNotEmpty) {
      updatedUser.house = house.trim();
    }

    await repository.updateUser(oldUser, updatedUser);

    return UserResult.success(updatedUser);
  }
}
