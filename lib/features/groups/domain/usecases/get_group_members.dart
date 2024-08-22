/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class GetGroupMembers
    implements UseCase<List<UserEntity>, GetGroupMembersParams> {
  final GroupRepository _groupRepository;

  GetGroupMembers(this._groupRepository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(
      GetGroupMembersParams params) async {
    return await _groupRepository.getGroupMembers(
      owner: params.owner,
      id: params.id,
    );
  }
}

class GetGroupMembersParams {
  final String owner;
  final String id;

  GetGroupMembersParams({
    required this.owner,
    required this.id,
  });
}
