import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../auth/auth_service.dart';
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
  bool isObscureData = true;

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
              expand: true,
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
        child: SingleChildScrollView(
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

              String cardNumber = MaskedTextController(
                mask: '0000 0000 0000 0000',
                text: cardItem.cardNumber.toString(),
              ).text;

              cardNumber = isObscureData
                  ? cardNumber.replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
                  : cardNumber;

              final String cardCvv = isObscureData
                  ? cardItem.cardCvvCode
                      .toString()
                      .replaceAll(RegExp(r'\d'), '*')
                  : cardItem.cardCvvCode.toString();

              final String cardPin = isObscureData
                  ? cardItem.cardPin.toString().replaceAll(RegExp(r'\d'), '*')
                  : cardItem.cardPin.toString();

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
                      obscureData: isObscureData,
                      isSwipeGestureEnabled: true,
                    ),
                    CupertinoFormSection(
                      children: <Widget>[
                        CupertinoFormRow(
                          child: CupertinoSwitch(
                            value: isObscureData,
                            onChanged: (bool value) async {
                              if (value) {
                                setState(() => isObscureData = true);
                              } else {
                                final bool auth =
                                    await AuthService.instance.authenticate();
                                if (auth) {
                                  setState(() => isObscureData = false);
                                }
                              }
                            },
                          ),
                          prefix: const Text('Obscure fields'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CupertinoFormSection(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: CupertinoColors.darkBackgroundGray,
                      ),
                      children: <Widget>[
                        cardDetailItem(
                          Icons.credit_card,
                          'Card Number',
                          cardNumber,
                        ),
                        cardDetailItem(
                          Icons.calendar_today,
                          'Expiry Date',
                          cardItem.cardExpiryDate ?? '',
                        ),
                        cardDetailItem(
                          Icons.text_fields,
                          'Card Holder Name',
                          cardItem.cardHolderName ?? '',
                        ),
                        cardDetailItem(
                          Icons.security,
                          'CVV Code',
                          cardCvv,
                        ),
                        cardDetailItem(
                          Icons.fiber_pin,
                          'Card Pin',
                          cardPin,
                        ),
                      ],
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

  GestureDetector cardDetailItem(
      IconData itemIcon, String itemLabel, String itemValue) {
    return GestureDetector(
      child: CupertinoFormRow(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(itemIcon),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    itemLabel,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ),
                Text(
                  itemValue,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () => Clipboard.setData(ClipboardData(text: itemValue)),
    );
  }

  Future<CardItem> getAndPopulateCard() async {
    final Map<String, dynamic> cardRow =
        await DatabseService.instance.queryOneCard(widget.cardId);
    return CardItem.fromJson(cardRow);
  }
}
