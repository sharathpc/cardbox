import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../databse_service.dart';
//import '../settings/settings_view.dart';
import '../manage_group/manage_group_view.dart';
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
                  ).then((_) => callStateChange(_));
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
                onChanged: (_) => callStateChange(_),
              ),
            ),
          ),
          FutureBuilder(
            future: getGroupsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              int childCount = 0;
              List<GroupItem> groupList = [];

              if (snapshot.connectionState != ConnectionState.done) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else {
                childCount = snapshot.data?.length ?? 0;
                groupList = snapshot.data ?? [];
              }
              if (groupList.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Icon(
                          Icons.group_work_outlined,
                          size: 100.0,
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                      Text(
                        'No Groups',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                      Text(
                        'Please add a Group',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final GroupItem groupItem = groupList[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: CupertinoColors.darkBackgroundGray,
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    groupItem.groupName,
                                    style: const TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        ManageGroupView.routeName,
                                        arguments: groupItem.groupId,
                                      ).then((_) => callStateChange(_));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            groupItem.cardsList.isEmpty
                                ? SizedBox(
                                    height: 180.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 12.0,
                                            bottom: 8.0,
                                          ),
                                          child: Icon(
                                            Icons.credit_card,
                                            size: 60.0,
                                            color: CupertinoColors.inactiveGray,
                                          ),
                                        ),
                                        Text(
                                          'No Cards',
                                          style: TextStyle(
                                            color: CupertinoColors.inactiveGray,
                                          ),
                                        ),
                                        Text(
                                          'Please add a Card',
                                          style: TextStyle(
                                            color: CupertinoColors.inactiveGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: groupItem.cardsList
                                        .map((CardItem item) {
                                      final BankItem bankItem = BankItem
                                          .banksList
                                          .firstWhere((element) =>
                                              element.bankCodeId ==
                                              groupItem.bankCodeId);
                                      return GestureDetector(
                                        child: CreditCardWidget(
                                          bankLogo: bankItem.bankLogo,
                                          cardTypeCodeId: item.cardTypeCodeId,
                                          cardColorCodeId: item.cardColorCodeId,
                                          accountName: item.accountName,
                                          accountNumber: item.accountNumber,
                                          ifsCode: item.ifsCode,
                                          cardNumber: item.cardNumber,
                                          expiryDate: item.cardExpiryDate,
                                          cardHolderName: item.cardHolderName,
                                          cvvCode: item.cardCvvCode,
                                          cardPin: item.cardPin,
                                          mobileNumber: item.mobileNumber,
                                          mobilePin: item.mobilePin,
                                          upiPin: item.upiPin,
                                          internetId: item.internetId,
                                          internetPassword:
                                              item.internetPassword,
                                          internetProfilePassword:
                                              item.internetProfilePassword,
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
                                  ),
                          ],
                        ),
                      );
                    },
                    childCount: childCount,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void callStateChange(_) {
    getGroupsFuture = getAllGroups();
    setState(() {});
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
