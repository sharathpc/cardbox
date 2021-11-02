import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

/// Displays detailed information about a CardItem.
class GroupDetailView extends StatelessWidget {
  const GroupDetailView({
    Key? key,
    required this.groupItem,
  }) : super(key: key);

  final GroupItem groupItem;
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
          onPressed: () {},
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
