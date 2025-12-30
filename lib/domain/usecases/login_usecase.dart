import '../repositories/auth_repository.dart';

import '../../data/models/user_model.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<UserModel> call(String employeeId, String password) async {
    return await _repository.login(employeeId, password);
  }
}
