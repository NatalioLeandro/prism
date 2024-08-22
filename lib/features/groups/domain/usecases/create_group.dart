/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class CreateGroup implements UseCase<GroupEntity, CreateGroupParams> {
  final GroupRepository _groupRepository;

  CreateGroup(this._groupRepository);

  @override
  Future<Either<Failure, GroupEntity>> call(CreateGroupParams params) async {
    return await _groupRepository.createGroup(
      owner: params.userId,
      name: params.name,
      description: params.description,
      members: params.members,
    );
  }
}

class CreateGroupParams {
  final String userId;
  final String name;
  final String description;
  final List<UserEntity> members;

  CreateGroupParams({
    required this.userId,
    required this.name,
    required this.description,
    required this.members,
  });
}
