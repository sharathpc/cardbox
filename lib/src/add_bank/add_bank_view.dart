import 'package:flutter/material.dart';
import 'package:cardbox/src/card_widget/credit_card_brand.dart';
import 'package:cardbox/src/card_widget/credit_card_form.dart';
import 'package:cardbox/src/card_widget/flutter_credit_card.dart';

/// Displays detailed information about a CardItem.
class AddBankView extends StatefulWidget {
  const AddBankView({Key? key}) : super(key: key);

  static const routeName = '/add_bank';

  @override
  State<AddBankView> createState() => _AddBankViewState();
}

class _AddBankViewState extends State<AddBankView> {
  String label = '';
  String bank = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
