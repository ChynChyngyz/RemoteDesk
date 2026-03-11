// features/admin/domain/repositories/i_admin_repository.dart

import 'package:front/features/admin/data/models/org_user_model.dart';
import 'package:front/features/admin/data/models/organization_model.dart';

abstract class IAdminRepository {

  Future<String> generateAgentToken();

  Future<OrganizationModel> createOrganization(
      String name,
      String city,
      String industry,
      );

  Future<OrganizationModel> getOrganization(int orgId);

  Future<List<OrgUserModel>> getUsers();

  Future<void> createUser(
      String phone,
      String password,
      String role,
      int organizationId
      );
}