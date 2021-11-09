import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../card_widget/credit_card_form.dart';
import '../card_widget/flutter_credit_card.dart';

import '../models/models.dart';
import '../databse_service.dart';

class ManageCardView extends StatefulWidget {
  const ManageCardView({
    Key? key,
    required this.bankCodeId,
    this.groupId,
    this.cardId,
  }) : super(key: key);

  static const routeName = '/add_card';
  final int bankCodeId;
  final int? groupId;
  final int? cardId;

  @override
  State<ManageCardView> createState() => _ManageCardViewState();
}

class _ManageCardViewState extends State<ManageCardView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future getCardFuture;
  late BankItem bank;
  CardItem cardItem = CardItem(cardTypeCodeId: 11001, cardColorCodeId: 12001);
  bool isBackFocused = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    bank = BankItem.banksList
        .firstWhere((item) => item.bankCodeId == widget.bankCodeId);
    isEdit = widget.cardId != null;
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
        middle: Text('${isEdit ? 'Edit' : 'Add'} Card'),
        trailing: TextButton(
          child: const Text(
            'Done',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final cardData = {
                DatabseService.columnCardId: widget.cardId,
                DatabseService.columnCardGroupId: widget.groupId,
                DatabseService.columnCardTypeCodeId: cardItem.cardTypeCodeId,
                DatabseService.columnCardColorCodeId: cardItem.cardColorCodeId,
                DatabseService.columnAccountNumber: cardItem.accountNumber,
                DatabseService.columnIFSCode: cardItem.ifsCode,
                DatabseService.columnCardNumber: cardItem.cardNumber,
                DatabseService.columnCardExpiryDate: cardItem.cardExpiryDate,
                DatabseService.columnCardHolderName: cardItem.cardHolderName,
                DatabseService.columnCardCvvCode: cardItem.cardCvvCode,
                DatabseService.columnCardPin: cardItem.cardPin,
                DatabseService.columnMobileNumber: cardItem.mobileNumber,
                DatabseService.columnMobilePin: cardItem.mobilePin,
                DatabseService.columnInternetId: cardItem.internetId,
                DatabseService.columnInternetPassword:
                    cardItem.internetPassword,
                DatabseService.columnInternetProfilePassword:
                    cardItem.internetProfilePassword,
              };
              if (isEdit) {
                await DatabseService.instance.updateCard(cardData);
              }
              Navigator.pop(
                context,
                CardItem.fromJson(cardData),
              );
            }
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder(
          future: getCardFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return Column(
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
                  showBackView: isBackFocused,
                  obscureData: false,
                  isSwipeGestureEnabled: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CreditCardForm(
                  formKey: formKey,
                  obscureData: false,
                  cardTypeCodeId: cardItem.cardTypeCodeId,
                  cardColorCodeId: cardItem.cardColorCodeId,
                  cardNumber: cardItem.cardNumber,
                  cvvCode: cardItem.cardCvvCode,
                  cardPin: cardItem.cardPin,
                  cardHolderName: cardItem.cardHolderName,
                  expiryDate: cardItem.cardExpiryDate,
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardItem.cardTypeCodeId = creditCardModel!.cardTypeCodeId;
      cardItem.cardColorCodeId = creditCardModel.cardColorCodeId;
      cardItem.cardNumber = creditCardModel.cardNumber;
      cardItem.cardExpiryDate = creditCardModel.expiryDate;
      cardItem.cardHolderName = creditCardModel.cardHolderName;
      cardItem.cardCvvCode = creditCardModel.cvvCode;
      cardItem.cardPin = creditCardModel.cardPin;
      isBackFocused = creditCardModel.isBackFocused;
    });
  }

  Future<void> getAndPopulateCard() async {
    if (isEdit) {
      final Map<String, dynamic> cardRow =
          await DatabseService.instance.queryOneCard(widget.cardId);
      cardItem = CardItem.fromJson(cardRow);
    }
    return;
  }
}
