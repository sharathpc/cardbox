import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../databse_service.dart';
//import '../settings/settings_view.dart';
import '../manage_group/manage_group_view.dart';
import '../group_detail/group_detail_view.dart';
import '../card_detail/card_detail_view.dart';

/// Displays a list of CardItems.
class GroupListView extends StatefulWidget {
  const GroupListView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  late Future getGroupsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getGroupsFuture = getAllGroups();
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
                    expand: true,
                    isDismissible: false,
                    enableDrag: false,
                    builder: (context) => const ManageGroupView(),
                  ).then((_) => getAllGroups());
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
                onChanged: callStateChange,
              ),
            ),
          ),
          FutureBuilder(
            future: getGroupsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              int childCount = 0;
              List<GroupItem> groupList = [];

              if (snapshot.connectionState != ConnectionState.done) {
                childCount = 1;
              } else {
                //Rprint(snapshot.data);
                childCount = snapshot.data?.length ?? 0;
                groupList = snapshot.data ?? [];
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    final GroupItem groupItem = groupList[index];
                    return GestureDetector(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(groupItem.groupName),
                            ),
                          ),
                          ...groupItem.cardsList.map((CardItem item) {
                            final BankItem bankItem = BankItem.banksList
                                .firstWhere((element) =>
                                    element.bankCodeId == groupItem.bankCodeId);
                            return GestureDetector(
                              child: CreditCardWidget(
                                bankLogo: bankItem.bankLogo,
                                cardTypeCodeId: item.cardTypeCodeId,
                                cardColorCodeId: item.cardColorCodeId,
                                cardNumber: item.cardNumber,
                                expiryDate: item.cardExpiryDate,
                                cardHolderName: item.cardHolderName,
                                cvvCode: item.cardCvvCode,
                                cardPin: item.cardPin,
                                showBackView: false,
                                obscureData: true,
                                isSwipeGestureEnabled: false,
                              ),
                              onTap: () => {
                                Navigator.pushNamed(
                                  context,
                                  CardDetailView.routeName,
                                  arguments: ManageCardModel(
                                    bankCodeId: bankItem.bankCodeId,
                                    groupId: groupItem.groupId,
                                    cardId: item.cardId,
                                  ),
                                ).then((_) => callStateChange(_)),
                              },
                            );
                          }).toList(),
                        ],
                      ),
                      onTap: () => {
                        Navigator.pushNamed(
                          context,
                          GroupDetailView.routeName,
                          arguments: groupItem.groupId,
                        ).then((_) => callStateChange(_)),
                      },
                    );
                  },
                  childCount: childCount,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  callStateChange(_) {
    setState(() {
      getGroupsFuture = getAllGroups();
    });
  }

  Future<List<GroupItem>> getAllGroups() async {
    final List<Map<String, dynamic>> groupList =
        await DatabseService.instance.queryAllGroup();

    return groupList
        .map((item) => GroupItem.fromJson(item))
        .where((item) => item.groupName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();
  }
}
