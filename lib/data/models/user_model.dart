class UserModel {
  final String id;

  final String employeeId;

  final String name;

  final String role;

  final String department;

  UserModel({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.role,
    required this.department,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'name': name,
      'role': role,
      'department': department,
    };
  }
}
