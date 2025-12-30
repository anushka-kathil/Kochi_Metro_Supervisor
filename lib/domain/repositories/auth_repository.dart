import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String employeeId, String password);

  Future<UserModel> signup({
    required String name,
    required String employeeId,
    required String password,
    required String department,
  });

  Future<void> logout();
}
