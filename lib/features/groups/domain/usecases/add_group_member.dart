/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class AddGroupMember implements UseCase<void, AddGroupMemberParams> {
  final GroupRepository _groupRepository;

  AddGroupMember(this._groupRepository);

  @override
  Future<Either<Failure, void>> call(AddGroupMemberParams params) async {
    return await _groupRepository.addGroupMember(
      owner: params.owner,
      id: params.id,
      user: params.user,
    );
  }
}

class AddGroupMemberParams {
  final String owner;
  final String id;
  final String user;

  AddGroupMemberParams({
    required this.owner,
    required this.id,
    required this.user,
  });
}
