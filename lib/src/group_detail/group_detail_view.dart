import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/models.dart';
import '../manage_group/manage_group_view.dart';

/// Displays detailed information about a CardItem.
class GroupDetailView extends StatelessWidget {
  const GroupDetailView({
    Key? key,
    this.groupId,
  }) : super(key: key);

  final int? groupId;
  static const routeName = '/group_detail';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Group Detail'),
        trailing: TextButton(
          child: const Text(
            'Edit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            showCupertinoModalBottomSheet(
              context: context,
              expand: true,
              isDismissible: false,
              enableDrag: false,
              builder: (context) => ManageGroupView(groupId: groupId),
            );
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
