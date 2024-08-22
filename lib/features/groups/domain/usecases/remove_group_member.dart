/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class RemoveGroupMember implements UseCase<void, RemoveGroupMemberParams> {
  final GroupRepository _groupRepository;

  RemoveGroupMember(this._groupRepository);

  @override
  Future<Either<Failure, void>> call(RemoveGroupMemberParams params) async {
    return await _groupRepository.removeGroupMember(
      owner: params.owner,
      id: params.id,
      user: params.user,
    );
  }
}

class RemoveGroupMemberParams {
  final String owner;
  final String id;
  final UserEntity user;

  RemoveGroupMemberParams({
    required this.owner,
    required this.id,
    required this.user,
  });
}
