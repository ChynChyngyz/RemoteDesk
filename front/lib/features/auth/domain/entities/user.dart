// features/auth/domain/entities/user.dart

class User {
  final int id;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.phone,
    required this.role,
  });
}
