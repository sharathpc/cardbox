import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cardbox/src/card_widget/credit_card_brand.dart';
import 'package:cardbox/src/card_widget/credit_card_form.dart';
import 'package:cardbox/src/card_widget/flutter_credit_card.dart';

class ManageCardView extends StatefulWidget {
  const ManageCardView({
    Key? key,
    this.cardId,
  }) : super(key: key);

  static const routeName = '/add_card';
  final int? cardId;

  @override
  State<ManageCardView> createState() => _ManageCardViewState();
}

class _ManageCardViewState extends State<ManageCardView> {
  String cardType = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardPin = '';
  bool isBackFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        trailing: const TextButton(
          child: Text(
            'Done',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: /* _groupNameController.text.isNotEmpty
              ? () => saveGroup(context)
              :  */
              null,
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
              cardType: cardType,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
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
                      cardType: cardType,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardPin: cardPin,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
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
      cardType = creditCardModel!.cardType;
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      cardPin = creditCardModel.cardPin;
      isBackFocused = creditCardModel.isBackFocused;
    });
  }
}
