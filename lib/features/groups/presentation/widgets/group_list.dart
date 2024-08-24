/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/config/routes/router.dart' as routes;
import 'package:prism/core/common/widgets/loader.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<GroupEntity> _allGroups = [];

  @override
  void initState() {
    super.initState();
    _loadAllGroups();
  }

  void _loadAllGroups() {
    context.read<GroupsBloc>().add(
          GroupsGetAllEvent(userId: context.read<UserCubit>().state.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is GroupsErrorState) {
          showMessageDialog(
            context,
            title: 'Ops...',
            message: state.message,
            type: AlertType.error,
            onConfirm: () {},
          );
        }
      },
      builder: (context, state) {
        if (state is GroupsLoadingState) {
          return const Loader();
        }

        if (state is GroupsSuccessState) {
          _allGroups = state.groups;
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _allGroups.length,
                itemBuilder: (context, index) {
                  final group = _allGroups[index];
                  return ListTile(
                    title: Text(group.name),
                    subtitle: Text(group.description),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        routes.groupDetail,
                        arguments: group,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
