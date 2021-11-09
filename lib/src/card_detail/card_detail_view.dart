import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/* import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart'; */

import '../models/models.dart';
import '../manage_card/manage_card_view.dart';

/// Displays detailed information about a CardItem.
class CardDetailView extends StatefulWidget {
  CardDetailView({
    Key? key,
    required this.bankCodeId,
    this.cardId,
  }) : super(key: key);

  static const routeName = '/card_detail';
  final int bankCodeId;
  int? cardId;

  @override
  State<CardDetailView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Card Detail'),
        trailing: TextButton(
          child: const Text(
            'Edit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            showCupertinoModalBottomSheet(
              context: context,
              expand: false,
              isDismissible: false,
              builder: (context) => ManageCardView(
                bankCodeId: widget.bankCodeId,
                cardId: widget.cardId,
              ),
            );
          },
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
