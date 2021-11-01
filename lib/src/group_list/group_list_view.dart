import 'package:cardbox/src/add_group/add_group_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/models.dart';
import '../databse_service.dart';
import '../settings/settings_view.dart';
import '../add_group/add_group_view.dart';

/// Displays a list of CardItems.
class GroupListView extends StatefulWidget {
  const GroupListView({
    Key? key,
    this.items = const [],
  }) : super(key: key);

  static const routeName = '/';

  final List<GroupItem> items;

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: null,
            stretch: true,
            largeTitle: const Text('Groups'),
            trailing: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.add),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    builder: (context) => const AddGroupView(),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: CupertinoSearchTextField(
                controller: _searchController,
                onChanged: onSearchTextChanged,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.blue[100 * (index % 9)],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Grid Item $index'),
                  ),
                );
              },
              childCount: 20,
            ),
          )
        ],
      ),
    );
  }

  onSearchTextChanged(String text) {
    setState(() {});
  }
}
