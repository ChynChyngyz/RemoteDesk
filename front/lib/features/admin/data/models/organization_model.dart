// features/admin/data/models/org_user_model.dart

class OrganizationModel {
  final int id;
  final String name;
  final String city;
  final String industry;
  final bool isActive;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.city,
    required this.industry,
    required this.isActive,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json["id"],
      name: json["name"],
      city: json["city"],
      industry: json["industry"],
      isActive: json["is_active"],
    );
  }
}