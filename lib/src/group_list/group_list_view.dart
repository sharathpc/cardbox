import 'package:cardbox/src/add_group/add_group_view.dart';
import 'package:cardbox/src/group_detail/group_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/models.dart';
import '../databse_service.dart';
//import '../settings/settings_view.dart';
import '../add_group/add_group_view.dart';

/// Displays a list of CardItems.
class GroupListView extends StatefulWidget {
  const GroupListView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<GroupItem>> getAllGroups() async {
    final List<Map<String, dynamic>> groupList =
        await DatabseService.instance.queryAllGroup();
    final List<GroupItem> filteredGroupList =
        groupList.map((item) => GroupItem.fromJson(item)).toList();
    return filteredGroupList
        .where((item) => item.groupName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();
  }

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
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: CupertinoSearchTextField(
                controller: _searchController,
                onChanged: onSearchTextChanged,
              ),
            ),
          ),
          FutureBuilder(
            future: getAllGroups(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              int childCount = 0;
              List<GroupItem> groupList = [];

              if (snapshot.connectionState != ConnectionState.done) {
                childCount = 1;
              } else {
                childCount = snapshot.data.length;
                groupList = snapshot.data;
              }
              return GroupSilverList(
                connectionState: snapshot.connectionState,
                groupList: groupList,
                childCount: childCount,
              );
            },
          )
        ],
      ),
    );
  }

  onSearchTextChanged(String text) {
    setState(() {});
  }
}

class GroupSilverList extends StatelessWidget {
  const GroupSilverList({
    Key? key,
    required this.connectionState,
    required this.groupList,
    required this.childCount,
  }) : super(key: key);

  final ConnectionState connectionState;
  final List<GroupItem> groupList;
  final int childCount;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          final GroupItem groupItem = groupList[index];
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(groupItem.groupName),
              ),
            ),
            onTap: () => {
              Navigator.pushNamed(
                context,
                GroupDetailView.routeName,
                arguments: groupItem,
              ),
            },
          );
        },
        childCount: childCount,
      ),
    );
  }
}
