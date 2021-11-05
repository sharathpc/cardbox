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
  late BankItem bank;
  int cardTypeCodeId = 11001;
  int cardColorCodeId = 12001;
  int? accountNumber;
  String? ifsCode;
  int? cardNumber;
  String? cardExpiryDate;
  String? cardHolderName;
  int? cardCvvCode;
  int? cardPin;
  int? mobileNumber;
  int? mobilePin;
  String? internetId;
  String? internetPassword;
  String? internetProfilePassword;
  bool isBackFocused = false;
  OutlineInputBorder? border;
  bool isEdit = false;

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
    bank = BankItem.banksList
        .firstWhere((item) => item.bankCodeId == widget.bankCodeId);
    isEdit = widget.cardId != null;
    /* if (isEdit) {
      getAndPopulateGroup();
    } */
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
                DatabseService.columnCardTypeCodeId: cardTypeCodeId,
                DatabseService.columnCardColorCodeId: cardColorCodeId,
                DatabseService.columnAccountNumber: accountNumber,
                DatabseService.columnIFSCode: ifsCode,
                DatabseService.columnCardNumber: cardNumber,
                DatabseService.columnCardExpiryDate: cardExpiryDate,
                DatabseService.columnCardHolderName: cardHolderName,
                DatabseService.columnCardCvvCode: cardCvvCode,
                DatabseService.columnCardPin: cardPin,
                DatabseService.columnMobileNumber: mobileNumber,
                DatabseService.columnMobilePin: mobilePin,
                DatabseService.columnInternetId: internetId,
                DatabseService.columnInternetPassword: internetPassword,
                DatabseService.columnInternetProfilePassword:
                    internetProfilePassword,
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
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            CreditCardWidget(
              bankLogo: bank.bankLogo,
              cardTypeCodeId: cardTypeCodeId,
              cardColorCodeId: cardColorCodeId,
              cardNumber: cardNumber,
              expiryDate: cardExpiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cardCvvCode,
              cardPin: cardPin,
              showBackView: isBackFocused,
              obscureData: false,
              isSwipeGestureEnabled: true,
              /* glassmorphismConfig: Glassmorphism(
                blurX: 10.0,
                blurY: 10.0,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4AA3F2),
                    Color(0xFFAF92FB),
                  ],
                  stops: [
                    0.3,
                    0.75,
                  ],
                ),
              ), */
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureData: false,
                      cardTypeCodeId: cardTypeCodeId,
                      cardColorCodeId: cardColorCodeId,
                      cardNumber: cardNumber,
                      cvvCode: cardCvvCode,
                      cardPin: cardPin,
                      cardHolderName: cardHolderName,
                      expiryDate: cardExpiryDate,
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardTypeCodeId = creditCardModel!.cardTypeCodeId;
      cardColorCodeId = creditCardModel.cardColorCodeId;
      cardNumber = creditCardModel.cardNumber;
      cardExpiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cardCvvCode = creditCardModel.cvvCode;
      cardPin = creditCardModel.cardPin;
      isBackFocused = creditCardModel.isBackFocused;
    });
  }
}
