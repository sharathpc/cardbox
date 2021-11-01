import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/models.dart';

/// Displays detailed information about a CardItem.
class AddGroupView extends StatefulWidget {
  const AddGroupView({Key? key}) : super(key: key);

  static const routeName = '/add_group';

  @override
  State<AddGroupView> createState() => _AddGroupViewState();
}

class _AddGroupViewState extends State<AddGroupView> {
  final TextEditingController _groupNameController = TextEditingController();
  String groupName = '';
  BankItem? selectedBank;

  @override
  void initState() {
    super.initState();
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
        middle: const Text('Add Group'),
        trailing: TextButton(
          child: const Text(
            'Done',
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
          children: [
            Padding(
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
            SizedBox(
              height: 180.0,
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: FixedExtentScrollController(
                  initialItem: selectedBank != null
                      ? BankItem.banksList.indexWhere(
                          (item) => item.bankCodeId == selectedBank!.bankCodeId)
                      : -1,
                ),
                onSelectedItemChanged: (index) {
                  setState(() => selectedBank = BankItem.banksList[index]);
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
            CupertinoTextFormFieldRow(
              autofocus: true,
              controller: _groupNameController,
              placeholder: 'Group Name:',
              onChanged: (String value) {
                setState(() => groupName = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
