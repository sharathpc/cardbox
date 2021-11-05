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
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  bool isEdit = false;
  late BankItem selectedBank;
  List<CardItem> cardsList = [];

  final String bankValidationMessage = 'Please select a bank';
  final String groupNameValidationMessage = 'Please input a valid name';

  FocusNode groupNameNode = FocusNode();

  @override
  void initState() {
    super.initState();

    selectedBank =
        BankItem.banksList.firstWhere((element) => element.bankCodeId == 10001);
    _bankController.text = selectedBank.bankName;

    isEdit = widget.groupId != null;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (isEdit) {
        getAndPopulateGroup();
      } /* else {
        showBankPicker(context);
      } */
    });
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
          onPressed: () {
            if (formKey.currentState!.validate()) {
              saveGroup(context);
            }
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Form(
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
                        child: Image.asset(selectedBank.bankLogo)),
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
                        FocusScope.of(context).requestFocus(groupNameNode);
                      },
                      placeholder: 'Bank',
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
                      autofocus: true,
                      padding: EdgeInsets.zero,
                      controller: _groupNameController,
                      focusNode: groupNameNode,
                      placeholder: 'Group Name',
                      keyboardType: TextInputType.text,
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
              cardsList.isEmpty
                  ? const SizedBox(
                      height: 40.0,
                    )
                  : SizedBox(
                      height: 250.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: cardsList.map((CardItem item) {
                            return CreditCardWidget(
                              bankLogo: selectedBank.bankLogo,
                              cardTypeCodeId: item.cardTypeCodeId,
                              cardBgColorCodeId: 12001,
                              cardNumber: item.cardNumber,
                              expiryDate: item.cardExpiryDate,
                              cardHolderName: item.cardHolderName,
                              cvvCode: item.cardCvvCode,
                              cardPin: item.cardPin,
                              showBackView: false,
                              obscureData: true,
                              isSwipeGestureEnabled: true,
                            );
                          }).toList(),
                        ),
                      ),
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
                        onTap: () => addCard(),
                      ),
                    ),
                    onTap: () => addCard(),
                  )
                ],
              ),
              Visibility(
                visible: isEdit,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40.0,
                    ),
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
                    )
                  ],
                ),
              ),
            ],
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

  addCard() {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ManageCardView(
        bankCodeId: selectedBank.bankCodeId,
        groupId: widget.groupId,
      ),
    ).then((card) {
      if (card != null) {
        setState(() {
          cardsList.add(card);
        });
      }
    });
  }

  getAndPopulateGroup() async {
    final Map<String, dynamic> queryRow =
        await DatabseService.instance.queryOneGroup(widget.groupId);
    final GroupItem groupItem = GroupItem.fromJson(queryRow);
    _groupNameController.text = groupItem.groupName;
    setState(() {
      selectedBank = BankItem.banksList
          .firstWhere((element) => element.bankCodeId == groupItem.bankCodeId);
      _bankController.text = selectedBank.bankName;
    });
  }

  saveGroup(BuildContext context) async {
    if (isEdit) {
      await DatabseService.instance.updateGroup({
        DatabseService.columnGroupId: widget.groupId,
        DatabseService.columnGroupName: _groupNameController.text,
        DatabseService.columnGroupBankCodeId: selectedBank.bankCodeId,
      });
    } else {
      await DatabseService.instance.insertGroup({
        DatabseService.columnGroupName: _groupNameController.text,
        DatabseService.columnGroupBankCodeId: selectedBank.bankCodeId,
      });
    }
    Navigator.pop(context);
  }

  deleteGroup() async {
    await DatabseService.instance.deleteGroup(widget.groupId ?? 0);
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
          message: cardsList.isNotEmpty
              ? Text('Delete Group and ${cardsList.length} Cards')
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
