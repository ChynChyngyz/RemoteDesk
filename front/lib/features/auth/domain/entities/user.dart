// features/auth/domain/entities/user.dart

class User {
  final int id;
  final String phone;
  final String role;
  final int organization;

  User({
    required this.id,
    required this.phone,
    required this.role,
    required this.organization,
  });
}
