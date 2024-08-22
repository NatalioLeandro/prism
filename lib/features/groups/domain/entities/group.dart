/* Project Imports */
import 'package:prism/core/common/entities/user.dart';

class GroupEntity {
  final String id;
  final String owner;
  final String name;
  final String description;
  final List<UserEntity> members;

  GroupEntity({
    required this.id,
    required this.owner,
    required this.name,
    required this.description,
    required this.members,
  });
}
