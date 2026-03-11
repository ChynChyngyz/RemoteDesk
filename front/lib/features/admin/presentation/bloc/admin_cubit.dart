// features/admin/presentation/bloc/admin_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/features/admin/domain/repositories/i_admin_repository.dart';
import 'package:front/features/admin/data/models/org_user_model.dart';
// import 'package:front/features/admin/data/models/organization_model.dart';


class AdminCubit extends Cubit<List<OrgUserModel>> {

  final IAdminRepository repository;

  AdminCubit(this.repository) : super([]);

  Future<void> loadUsers() async {

    final users = await repository.getUsers();

    emit(users);
  }

  Future<void> createUser(
      String phone,
      String password,
      String role,
      int orgId
      ) async {

    await repository.createUser(phone, password, role, orgId);

    loadUsers();
  }
}