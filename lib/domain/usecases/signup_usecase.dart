import '../repositories/auth_repository.dart';

import '../../data/models/user_model.dart';

class SignupUsecase {
  final AuthRepository _repository;

  SignupUsecase(this._repository);

  Future<UserModel> call({
    required String name,
    required String employeeId,
    required String password,
    required String department,
  }) async {
    return await _repository.signup(
      name: name,
      employeeId: employeeId,
      password: password,
      department: department,
    );
  }
}
