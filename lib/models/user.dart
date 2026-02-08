enum UserRole { admin_stan, siswa }

class User {
  final int id;
  final String username;
  final String password;
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role.toString(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Parse role from string to enum
    UserRole role;
    if (json['role'] is String) {
      final roleStr = json['role'].toLowerCase();
      if (roleStr.contains('admin')) {
        role = UserRole.admin_stan;
      } else {
        role = UserRole.siswa;
      }
    } else {
      role = UserRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => UserRole.siswa,
      );
    }
    
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'] ?? '',
      role: role,
    );
  }
}
