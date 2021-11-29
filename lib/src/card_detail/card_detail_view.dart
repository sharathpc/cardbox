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
                      accountName: cardItem.accountName,
                      accountNumber: cardItem.accountNumber,
                      ifsCode: cardItem.ifsCode,
                      cardNumber: cardItem.cardNumber,
                      expiryDate: cardItem.cardExpiryDate,
                      cardHolderName: cardItem.cardHolderName,
                      cvvCode: cardItem.cardCvvCode,
                      cardPin: cardItem.cardPin,
                      mobileNumber: cardItem.mobileNumber,
                      mobilePin: cardItem.mobilePin,
                      upiPin: cardItem.upiPin,
                      internetId: cardItem.internetId,
                      internetPassword: cardItem.internetPassword,
                      internetProfilePassword: cardItem.internetProfilePassword,
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
                                isObscureData = true;
                              } else {
                                final bool auth =
                                    await AuthService.instance.authenticate();
                                if (auth) {
                                  isObscureData = false;
                                }
                              }
                              setState(() {});
                            },
                          ),
                          prefix: const Text('Obscure fields'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    getCardTypeForm(
                      cardItem.cardTypeCodeId,
                      cardItem,
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

  Widget getCardTypeForm(int cardTypeCodeId, CardItem cardItem) {
    switch (cardTypeCodeId) {
      case 11001:
        return bankCardForm(cardItem);
      case 11002:
      case 11003:
        return atmCardForm(cardItem);
      case 11004:
        return mobileCardForm(cardItem);
      case 11005:
        return internetCardForm(cardItem);
      default:
        return const SizedBox();
    }
  }

  CupertinoFormSection bankCardForm(CardItem cardItem) {
    final String accountNumber = isObscureData
        ? cardItem.accountNumber.toString().replaceAll(RegExp(r'\d'), '*')
        : cardItem.accountNumber.toString();

    return CupertinoFormSection(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: CupertinoColors.darkBackgroundGray,
      ),
      children: <Widget>[
        cardDetailItem(
          Icons.text_fields,
          'Account Name',
          cardItem.accountName ?? '',
        ),
        cardDetailItem(
          Icons.dialpad,
          'Account Number',
          accountNumber,
        ),
        cardDetailItem(
          Icons.account_balance,
          'IFSC Code',
          cardItem.ifsCode ?? '',
        ),
      ],
    );
  }

  CupertinoFormSection atmCardForm(CardItem cardItem) {
    String cardNumber = MaskedTextController(
      mask: '0000 0000 0000 0000',
      text: cardItem.cardNumber.toString(),
    ).text;

    cardNumber = isObscureData
        ? cardNumber.replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
        : cardNumber;

    final String cardCvv = isObscureData
        ? cardItem.cardCvvCode.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.cardCvvCode.toString();

    final String cardPin = isObscureData
        ? cardItem.cardPin.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.cardPin.toString();

    return CupertinoFormSection(
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
    );
  }

  CupertinoFormSection mobileCardForm(CardItem cardItem) {
    String mobileNumber = MaskedTextController(
      mask: '000-000-0000',
      text: cardItem.cardNumber.toString(),
    ).text;

    mobileNumber = isObscureData
        ? cardItem.mobileNumber
            .toString()
            .replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
        : cardItem.mobileNumber.toString();

    final String mobilePin = isObscureData
        ? cardItem.mobilePin.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.mobilePin.toString();

    final String upiPin = isObscureData
        ? cardItem.upiPin.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.upiPin.toString();

    return CupertinoFormSection(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: CupertinoColors.darkBackgroundGray,
      ),
      children: <Widget>[
        cardDetailItem(
          Icons.stay_current_portrait,
          'Mobile Number',
          mobileNumber,
        ),
        cardDetailItem(
          Icons.security,
          'Mobile Pin',
          mobilePin,
        ),
        cardDetailItem(
          Icons.security,
          'UPI Pin',
          upiPin,
        ),
      ],
    );
  }

  CupertinoFormSection internetCardForm(CardItem cardItem) {
    final String internetPassword = isObscureData
        ? cardItem.internetPassword.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.internetPassword.toString();

    final String internetProfilePassword = isObscureData
        ? cardItem.internetProfilePassword
            .toString()
            .replaceAll(RegExp(r'\S'), '*')
        : cardItem.internetProfilePassword.toString();

    return CupertinoFormSection(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: CupertinoColors.darkBackgroundGray,
      ),
      children: <Widget>[
        cardDetailItem(
          Icons.language,
          'Internet ID',
          cardItem.internetId ?? '',
        ),
        cardDetailItem(
          Icons.security,
          'Internet Password',
          internetPassword,
        ),
        cardDetailItem(
          Icons.security,
          'Internet Profile Password',
          internetProfilePassword,
        ),
      ],
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
