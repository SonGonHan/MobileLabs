import '../../entities/user.dart';

class UserResult {
  final bool isSuccess;
  final User? user;
  final List<String> errors;

  const UserResult._({
    required this.isSuccess,
    this.user,
    this.errors = const [],
  });

  factory UserResult.success(User user) {
    return UserResult._(
      isSuccess: true,
      user: user,
      errors: const [],
    );
  }

  factory UserResult.failure(List<String> errors) {
    return UserResult._(
      isSuccess: false,
      user: null,
      errors: errors,
    );
  }
}
