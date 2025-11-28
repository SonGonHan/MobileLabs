import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetByLogin {
  final UserRepository repository;
  GetByLogin(this.repository);

  Future<User?> call({required String login}) => repository.getByLogin(login);
}