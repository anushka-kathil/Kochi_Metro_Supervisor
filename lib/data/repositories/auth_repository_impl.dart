import '../models/user_model.dart';

import '../services/api_service.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<UserModel> login(String employeeId, String password) async {
    // Simulate API call - replace with actual implementation

    await Future.delayed(const Duration(seconds: 2));

    // Mock validation

    if (employeeId == 'SV0401' && password == 'admin123') {
      return UserModel(
        id: '1',
        employeeId: employeeId,
        name: 'John Supervisor',
        role: 'Supervisor',
        department: 'Operations',
      );
    } else {
      throw Exception('Invalid credentials');
    }

    // Actual implementation would be:

    // final response = await _apiService.post('/auth/login', data: {

    //   'employee_id': employeeId,

    //   'password': password,

    // });

    // return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String employeeId,
    required String password,
    required String department,
  }) async {
    // Simulate API call

    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      employeeId: employeeId,
      name: name,
      role: 'Supervisor',
      department: department,
    );
  }

  @override
  Future<void> logout() async {
    // Implement logout logic

    await Future.delayed(const Duration(milliseconds: 500));
  }
}
