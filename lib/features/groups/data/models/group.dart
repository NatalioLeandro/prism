/* Project Imports */
import 'package:prism/features/groups/domain/entities/group.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.owner,
    required super.name,
    required super.description,
    required super.members,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      description: json['description'],
      members: json['members'].map<String>((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'description': description,
      'members': members,
    };
  }

  GroupModel copyWith({
    String? id,
    String? owner,
    String? name,
    String? description,
    List<String>? members,
  }) {
    return GroupModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
    );
  }
}
