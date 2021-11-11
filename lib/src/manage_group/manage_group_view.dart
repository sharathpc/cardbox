import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../databse_service.dart';
import '../group_list/group_list_view.dart';
import '../manage_card/manage_card_view.dart';

/// Displays detailed information about a CardItem.
class ManageGroupView extends StatefulWidget {
  const ManageGroupView({
    Key? key,
    this.groupId,
  }) : super(key: key);

  static const routeName = '/manage_group';
  final int? groupId;

  @override
  State<ManageGroupView> createState() => _ManageGroupViewState();
}

class _ManageGroupViewState extends State<ManageGroupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future getGroupFuture;
  bool isEdit = false;
  GroupItem groupItem = GroupItem(
    bankCodeId: 10001,
    groupName: '',
    cardsList: [],
  );
  BankItem selectedBank =
      BankItem.banksList.firstWhere((element) => element.bankCodeId == 10001);

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  final String bankValidationMessage = 'Please select a bank';
  final String groupNameValidationMessage = 'Please input a valid name';

  FocusNode groupNameNode = FocusNode();

  @override
  void initState() {
    super.initState();

    groupItem.groupId = widget.groupId;
    _bankController.text = selectedBank.bankName;

    isEdit = groupItem.groupId != null;
    getGroupFuture = getAndPopulateGroup();
  }

  @override
  void dispose() {
    groupNameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text('${isEdit ? 'Edit' : 'Add'} Group'),
        trailing: TextButton(
          child: const Text(
            'Done',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await saveGroup();
              Navigator.pop(context);
            }
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getGroupFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: 50.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(selectedBank.bankLogo),
                          ),
                        ),
                      ),
                    ),
                    CupertinoFormSection(
                      children: [
                        CupertinoFormRow(
                          padding: EdgeInsets.zero,
                          child: CupertinoTextFormFieldRow(
                            readOnly: true,
                            controller: _bankController,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(groupNameNode);
                            },
                            placeholder: 'Bank',
                            prefix: const Icon(Icons.account_balance),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return bankValidationMessage;
                              }
                              return null;
                            },
                            onTap: () => showBankPicker(context),
                          ),
                        ),
                        CupertinoFormRow(
                          child: CupertinoTextFormFieldRow(
                            autofocus: !isEdit,
                            padding: EdgeInsets.zero,
                            controller: _groupNameController,
                            focusNode: groupNameNode,
                            placeholder: 'Group Name',
                            keyboardType: TextInputType.text,
                            prefix: const Icon(Icons.group_work_outlined),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return groupNameValidationMessage;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CupertinoFormSection(
                      children: [
                        GestureDetector(
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            child: CupertinoTextFormFieldRow(
                              readOnly: true,
                              prefix: const Icon(
                                CupertinoIcons.add_circled_solid,
                                color: CupertinoColors.systemGreen,
                              ),
                              initialValue: 'Add Card',
                              onTap: () => manageCard(null),
                            ),
                          ),
                          onTap: () => manageCard(null),
                        )
                      ],
                    ),
                    groupItem.cardsList.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 8.0,
                                ),
                                child: Icon(
                                  Icons.credit_card,
                                  size: 80.0,
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
                              SizedBox(
                                height: 40.0,
                              ),
                            ],
                          )
                        : Column(
                            children: groupItem.cardsList.map((CardItem item) {
                              return GestureDetector(
                                child: CreditCardWidget(
                                  bankLogo: selectedBank.bankLogo,
                                  cardTypeCodeId: item.cardTypeCodeId,
                                  cardColorCodeId: item.cardColorCodeId,
                                  cardNumber: item.cardNumber,
                                  expiryDate: item.cardExpiryDate,
                                  cardHolderName: item.cardHolderName,
                                  cvvCode: item.cardCvvCode,
                                  cardPin: item.cardPin,
                                  showBackView: false,
                                  obscureData: true,
                                  isSwipeGestureEnabled: true,
                                ),
                                onTap: () => manageCard(item.cardId),
                              );
                            }).toList(),
                          ),
                    Visibility(
                      visible: isEdit,
                      child: Column(
                        children: [
                          CupertinoFormSection(
                            children: [
                              CupertinoFormRow(
                                padding: EdgeInsets.zero,
                                child: CupertinoTextFormFieldRow(
                                  readOnly: true,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemRed,
                                  ),
                                  initialValue: 'Delete Group',
                                  onTap: () => showDeleteGroupSheet(),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 80.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showBankPicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => SizedBox(
        height: 280,
        child: CupertinoPicker(
          backgroundColor: CupertinoDynamicColor.resolve(
            CupertinoColors.systemBackground,
            context,
          ),
          scrollController: FixedExtentScrollController(
            initialItem: BankItem.banksList.indexWhere(
                (item) => item.bankCodeId == selectedBank.bankCodeId),
          ),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedBank = BankItem.banksList[index];
              _bankController.text = selectedBank.bankName;
            });
          },
          itemExtent: 32.0,
          children: BankItem.banksList.map((BankItem item) {
            return Center(
              heightFactor: double.maxFinite,
              widthFactor: double.infinity,
              child: Text(
                item.bankName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  manageCard(int? cardId) async {
    await saveGroup();
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ManageCardView(
        bankCodeId: selectedBank.bankCodeId,
        groupId: groupItem.groupId,
        cardId: cardId,
      ),
    ).then((_) => getAndPopulateGroup());
  }

  getAndPopulateGroup() async {
    if (isEdit) {
      final Map<String, dynamic> groupRow =
          await DatabseService.instance.queryOneGroup(groupItem.groupId);
      groupItem = GroupItem.fromJson(groupRow);
      setState(() {
        selectedBank = BankItem.banksList.firstWhere(
            (element) => element.bankCodeId == groupItem.bankCodeId);
        _groupNameController.text = groupItem.groupName;
        _bankController.text = selectedBank.bankName;
      });
    }
  }

  saveGroup() async {
    if (isEdit) {
      await DatabseService.instance.updateGroup({
        DatabseService.columnGroupId: groupItem.groupId,
        DatabseService.columnGroupName: _groupNameController.text,
        DatabseService.columnGroupBankCodeId: selectedBank.bankCodeId,
      });
    } else {
      groupItem.groupId = await DatabseService.instance.insertGroup({
        DatabseService.columnGroupName: _groupNameController.text,
        DatabseService.columnGroupBankCodeId: selectedBank.bankCodeId,
      });
      isEdit = true;
    }
  }

  deleteGroup() async {
    await DatabseService.instance.deleteGroup(groupItem.groupId ?? 0);
    Navigator.popUntil(
      context,
      ModalRoute.withName(GroupListView.routeName),
    );
  }

  showDeleteGroupSheet() {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: groupItem.cardsList.isNotEmpty
              ? Text('Delete Group and ${groupItem.cardsList.length} Cards')
              : null,
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                'Delete Group',
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                deleteGroup();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }
}
