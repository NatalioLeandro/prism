/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class GetGroups implements UseCase<List<GroupEntity>, GetGroupsParams> {
  final GroupRepository _groupRepository;

  GetGroups(this._groupRepository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(
      GetGroupsParams params) async {
    return await _groupRepository.getGroups(
      owner: params.owner,
    );
  }
}

class GetGroupsParams {
  final String owner;

  GetGroupsParams({
    required this.owner,
  });
}
