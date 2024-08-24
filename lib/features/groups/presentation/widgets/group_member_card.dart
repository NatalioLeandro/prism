import 'package:flutter/material.dart';
import 'package:prism/core/common/entities/user.dart';

class MemberCard extends StatelessWidget {
  final UserEntity member;

  const MemberCard({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          member.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          member.email, // Supondo que `UserEntity` tem um campo `email`
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Text(
            member.name.isNotEmpty ? member.name[0] : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
