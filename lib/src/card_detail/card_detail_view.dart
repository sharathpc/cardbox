import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../databse_service.dart';
import '../manage_card/manage_card_view.dart';

/// Displays detailed information about a CardItem.
class CardDetailView extends StatefulWidget {
  const CardDetailView({
    Key? key,
    required this.bankCodeId,
    this.groupId,
    this.cardId,
  }) : super(key: key);

  static const routeName = '/card_detail';
  final int bankCodeId;
  final int? groupId;
  final int? cardId;

  @override
  State<CardDetailView> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends State<CardDetailView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future getCardFuture;
  late BankItem bank;

  @override
  void initState() {
    super.initState();
    bank = BankItem.banksList
        .firstWhere((item) => item.bankCodeId == widget.bankCodeId);
    getCardFuture = getAndPopulateCard();
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
              isDismissible: false,
              enableDrag: false,
              builder: (context) => ManageCardView(
                bankCodeId: widget.bankCodeId,
                groupId: widget.groupId,
                cardId: widget.cardId,
              ),
            ).then((_) => getCardFuture = getAndPopulateCard());
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder(
          future: getCardFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            late CardItem cardItem;
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              cardItem = snapshot.data;
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  CreditCardWidget(
                    bankLogo: bank.bankLogo,
                    cardTypeCodeId: cardItem.cardTypeCodeId,
                    cardColorCodeId: cardItem.cardColorCodeId,
                    cardNumber: cardItem.cardNumber,
                    expiryDate: cardItem.cardExpiryDate,
                    cardHolderName: cardItem.cardHolderName,
                    cvvCode: cardItem.cardCvvCode,
                    cardPin: cardItem.cardPin,
                    showBackView: false,
                    obscureData: false,
                    isSwipeGestureEnabled: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<CardItem> getAndPopulateCard() async {
    final Map<String, dynamic> cardRow =
        await DatabseService.instance.queryOneCard(widget.cardId);
    return CardItem.fromJson(cardRow);
  }
}
