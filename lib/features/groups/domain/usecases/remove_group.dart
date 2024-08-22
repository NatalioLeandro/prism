/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class RemoveGroup implements UseCase<void, RemoveGroupParams> {
  final GroupRepository _groupRepository;

  RemoveGroup(this._groupRepository);

  @override
  Future<Either<Failure, void>> call(RemoveGroupParams params) async {
    return await _groupRepository.removeGroup(
      owner: params.userId,
      id: params.id,
    );
  }
}

class RemoveGroupParams {
  final String userId;
  final String id;

  RemoveGroupParams({
    required this.userId,
    required this.id,
  });
}
