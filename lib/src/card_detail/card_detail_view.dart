import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import '../card_widget/flutter_credit_card.dart';

import '../helper.dart';
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
                      height: 10,
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
                      upiId: cardItem.upiId,
                      upiPin: cardItem.upiPin,
                      internetId: cardItem.internetId,
                      internetUsername: cardItem.internetUsername,
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
                          prefix: Row(
                            children: const [
                              Icon(Icons.remove_red_eye),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Obscure fields'),
                            ],
                          ),
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
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      child: const Icon(CupertinoIcons.share),
                      onTap: () => shareCard(context, bank, cardItem),
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
      case 11006:
        return upiCardForm(cardItem);
      default:
        return const SizedBox();
    }
  }

  CupertinoFormSection bankCardForm(CardItem cardItem) {
    final String accountNumber = isObscureData
        ? cardItem.accountNumber.toString().replaceAll(RegExp(r'\d'), '*')
        : cardItem.accountNumber.toString();

    return CupertinoFormSection(
      decoration: _cardDetailBoxDecoration(),
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
      decoration: _cardDetailBoxDecoration(),
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

    return CupertinoFormSection(
      decoration: _cardDetailBoxDecoration(),
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
      decoration: _cardDetailBoxDecoration(),
      children: <Widget>[
        cardDetailItem(
          Icons.language,
          'Internet ID',
          cardItem.internetId ?? '',
        ),
        cardDetailItem(
          Icons.text_fields,
          'Internet Username',
          cardItem.internetUsername ?? '',
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

  CupertinoFormSection upiCardForm(CardItem cardItem) {
    final String upiId = isObscureData
        ? cardItem.upiId.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.upiId.toString();

    final String upiPin = isObscureData
        ? cardItem.upiPin.toString().replaceAll(RegExp(r'\S'), '*')
        : cardItem.upiPin.toString();

    return CupertinoFormSection(
      decoration: _cardDetailBoxDecoration(),
      children: <Widget>[
        cardDetailItem(
          Icons.center_focus_strong_outlined,
          'UPI ID',
          upiId,
        ),
        cardDetailItem(
          Icons.security,
          'UPI Pin',
          upiPin,
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
                  style: TextStyle(
                    color: Helper.instance.isDarkMode(context)
                        ? CupertinoColors.white
                        : CupertinoColors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: itemValue));
        HapticFeedback.lightImpact();
      },
    );
  }

  BoxDecoration _cardDetailBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Helper.instance.isDarkMode(context)
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.lightBackgroundGray,
    );
  }

  Future<CardItem> getAndPopulateCard() async {
    final Map<String, dynamic> cardRow =
        await DatabseService.instance.queryOneCard(widget.cardId);
    return CardItem.fromJson(cardRow);
  }

  void shareCard(BuildContext context, BankItem bank, CardItem card) async {
    final box = context.findRenderObject() as RenderBox?;

    late String shareText;

    switch (card.cardTypeCodeId) {
      case 11001:
        shareText = '''Bank Name: ${bank.bankName}
Account Name: ${card.accountName}
Account Number: ${card.accountNumber}
IFSC Code: ${card.ifsCode}''';
        break;
      case 11002:
      case 11003:
        shareText = '''Bank Name: ${bank.bankName}
Card Number: ${card.cardNumber}
Expiry Date: ${card.cardExpiryDate}
Card Holder Name: ${card.cardHolderName}
CVV Code: ${card.cardCvvCode}
Card Pin: ${isObscureData ? '****' : card.cardCvvCode}''';
        break;
      case 11004:
        shareText = '''Bank Name: ${bank.bankName}
Mobile Number: ${card.mobileNumber}
Mobile Pin: N/A''';
        break;
      case 11005:
        shareText = '''Bank Name: ${bank.bankName}
Internet ID: ${card.internetId}
Internet Username: ${card.internetUsername}
Internet Password: ${isObscureData ? '****' : card.internetPassword}
Internet Profile Password: ${isObscureData ? '****' : card.internetProfilePassword}''';
        break;
      case 11006:
        shareText = '''Bank Name: ${bank.bankName}
UPI ID: ${card.upiId}
UPI Pin: ${card.upiPin}''';
        break;
    }

    await Share.share(
      shareText,
      subject: 'Card Data',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
