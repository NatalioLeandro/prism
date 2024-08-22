/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class GetGroup implements UseCase<GroupEntity, GetGroupParams> {
  final GroupRepository _groupRepository;

  GetGroup(this._groupRepository);

  @override
  Future<Either<Failure, GroupEntity>> call(GetGroupParams params) async {
    return await _groupRepository.getGroup(
      owner: params.owner,
      id: params.id,
    );
  }
}

class GetGroupParams {
  final String owner;
  final String id;

  GetGroupParams({
    required this.owner,
    required this.id,
  });
}
