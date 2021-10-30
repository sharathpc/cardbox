import 'package:flutter/material.dart';
import 'package:cardbox/src/card_widget/credit_card_brand.dart';
import 'package:cardbox/src/card_widget/credit_card_form.dart';
import 'package:cardbox/src/card_widget/flutter_credit_card.dart';

/// Displays detailed information about a CardItem.
class AddCardView extends StatefulWidget {
  const AddCardView({Key? key}) : super(key: key);

  static const routeName = '/add_card';

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  String cardType = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardPin = '';
  bool isBackFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
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
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      cardTypeDecoration: InputDecoration(
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Card Type',
                      ),
                      expiryDateDecoration: InputDecoration(
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Card Holder',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardPinDecoration: InputDecoration(
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Card Pin',
                        hintText: 'XXXX',
                      ),
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
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      cardPin = creditCardModel.cardPin;
      isBackFocused = creditCardModel.isBackFocused;
    });
  }
}
