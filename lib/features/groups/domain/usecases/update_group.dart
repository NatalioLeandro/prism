/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UpdateGroup implements UseCase<GroupEntity, UpdateGroupParams> {
  final GroupRepository _groupRepository;

  UpdateGroup(this._groupRepository);

  @override
  Future<Either<Failure, GroupEntity>> call(UpdateGroupParams params) async {
    return await _groupRepository.updateGroup(
      owner: params.userId,
      id: params.id,
      name: params.name,
      description: params.description,
      members: params.members,
    );
  }
}

class UpdateGroupParams {
  final String userId;
  final String id;
  final String name;
  final String description;
  final List<String> members;

  UpdateGroupParams({
    required this.userId,
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });
}
