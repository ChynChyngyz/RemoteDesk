// features/admin/data/models/org_user_model.dart

import 'organization_model.dart';

class OrgUserModel {
  final int id;
  final String phone;
  final String role;
  final OrganizationModel organization;

  OrgUserModel({
    required this.id,
    required this.phone,
    required this.role,
    required this.organization,
  });

  factory OrgUserModel.fromJson(Map<String, dynamic> json) {
    return OrgUserModel(
      id: json["id"],
      phone: json["phone"],
      role: json["role"],
      organization: OrganizationModel.fromJson(json["organization"]),
    );
  }
}