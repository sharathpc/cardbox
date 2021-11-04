import 'package:cardbox/src/manage_card/manage_card_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/models.dart';
import '../databse_service.dart';

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
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  bool isEdit = false;
  BankItem? selectedBank;

  @override
  void initState() {
    super.initState();
    isEdit = widget.groupId != null;
    if (isEdit) {
      getAndPopulateGroup();
    }
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
          onPressed: _groupNameController.text.isNotEmpty
              ? () => saveGroup(context)
              : null,
        ),
      ),
      child: SafeArea(
        bottom: false,
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
                    child: selectedBank != null
                        ? Image.asset(selectedBank!.bankLogo)
                        : null,
                  ),
                ),
              ),
            ),
            CupertinoFormSection(
              children: [
                CupertinoFormRow(
                  child: CupertinoTextFormFieldRow(
                      padding: EdgeInsets.zero,
                      autofocus: true,
                      controller: _groupNameController,
                      placeholder: 'Group Name'),
                ),
                CupertinoFormRow(
                  padding: EdgeInsets.zero,
                  child: CupertinoTextFormFieldRow(
                    readOnly: true,
                    controller: _bankController,
                    placeholder: 'Bank Name',
                    onTap: () => showBankPicker(context),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            CupertinoFormSection(
              children: [
                GestureDetector(
                  child: CupertinoFormRow(
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text('Add Card'),
                      ],
                    ),
                  ),
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ManageCardView(
                        bankCodeId: selectedBank!.bankCodeId,
                      ),
                    ).then((value) => print(value));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void showBankPicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => SizedBox(
        height: 400,
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          scrollController: FixedExtentScrollController(
            initialItem: selectedBank != null
                ? BankItem.banksList.indexWhere(
                    (item) => item.bankCodeId == selectedBank!.bankCodeId)
                : -1,
          ),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedBank = BankItem.banksList[index];
              _bankController.text = selectedBank!.bankName;
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

  getAndPopulateGroup() async {
    final Map<String, dynamic> queryRow =
        await DatabseService.instance.queryOneGroup(widget.groupId);
    final GroupItem groupItem = GroupItem.fromJson(queryRow);
    _groupNameController.text = groupItem.groupName;
    setState(() {
      selectedBank = BankItem.banksList
          .firstWhere((element) => element.bankCodeId == groupItem.bankCodeId);
    });
    _bankController.text = selectedBank!.bankName;
  }

  saveGroup(BuildContext context) async {
    if (isEdit) {
      await DatabseService.instance.updateGroup({
        DatabseService.columnGroupId: widget.groupId,
        DatabseService.columnGroupName: _groupNameController.text,
        DatabseService.columnGroupBankCodeId: selectedBank!.bankCodeId,
      });
    } else {
      await DatabseService.instance.insertGroup({
        DatabseService.columnGroupName: _groupNameController.text,
        DatabseService.columnGroupBankCodeId: selectedBank!.bankCodeId,
      });
    }
    Navigator.pop(context);
  }
}
