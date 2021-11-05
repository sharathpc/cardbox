import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cardbox/src/card_widget/credit_card_brand.dart';
import 'package:cardbox/src/card_widget/credit_card_form.dart';
import 'package:cardbox/src/card_widget/flutter_credit_card.dart';

import '../models/models.dart';

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
  String accountNumber = '';
  String ifsCode = '';
  String cardNumber = '';
  String cardExpiryDate = '';
  String cardHolderName = '';
  String cardCvvCode = '';
  String cardPin = '';
  String mobileNumber = '';
  String mobilePin = '';
  String internetId = '';
  String internetPassword = '';
  String internetProfilePassword = '';
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
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (widget.cardId == null) {
                Navigator.pop(
                  context,
                  CardItem(
                    cardId: widget.cardId ?? 0,
                    cardGroupId: widget.groupId ?? 0,
                    cardTypeCodeId: cardTypeCodeId,
                    accountNumber: int.tryParse(accountNumber),
                    ifsCode: ifsCode,
                    cardNumber: int.tryParse(cardNumber.replaceAll(' ', '')),
                    cardExpiryDate: cardExpiryDate,
                    cardHolderName: cardHolderName,
                    cardCvvCode: int.tryParse(cardCvvCode),
                    cardPin: int.tryParse(cardPin),
                    mobileNumber: int.tryParse(mobileNumber),
                    mobilePin: int.tryParse(mobilePin),
                    internetId: internetId,
                    internetPassword: internetPassword,
                    internetProfilePassword: internetProfilePassword,
                  ),
                );
              } else {}
            }
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            CreditCardWidget(
              bankLogo: bank.bankLogo,
              cardTypeCodeId: cardTypeCodeId,
              cardNumber: cardNumber,
              expiryDate: cardExpiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cardCvvCode,
              cardPin: cardPin,
              showBackView: isBackFocused,
              obscureCardNumber: false,
              obscureCardCvv: false,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              glassmorphismConfig: Glassmorphism(
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
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      obscurePin: true,
                      cardTypeCodeId: cardTypeCodeId,
                      cardNumber: cardNumber,
                      cvvCode: cardCvvCode,
                      cardPin: cardPin,
                      cardHolderName: cardHolderName,
                      expiryDate: cardExpiryDate,
                      themeColor: Colors.blue,
                      textColor: Colors.white,
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
      cardNumber = creditCardModel.cardNumber;
      cardExpiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cardCvvCode = creditCardModel.cvvCode;
      cardPin = creditCardModel.cardPin;
      isBackFocused = creditCardModel.isBackFocused;
    });
  }
}
