import 'package:flutter/material.dart';
/* import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart'; */

import '../models/models.dart';

/// Displays detailed information about a CardItem.
class CardDetailView extends StatelessWidget {
  const CardDetailView({
    Key? key,
    required this.cardItem,
  }) : super(key: key);

  final CardItem cardItem;
  static const routeName = '/card_detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
      ),
      body: const SizedBox(
        height: 20,
      ),
      /* Center(
        child: CreditCardWidget(
          cardNumber: cardItem.cardNumber,
          expiryDate: cardItem.expiryDate,
          cardHolderName: cardItem.cardHolderName,
          cvvCode: cardItem.cvvCode,
          showBackView: false,
          isHolderNameVisible: true,
          isChipVisible: false,
          cardBgColor: Colors.black,
          obscureCardNumber: false,
          obscureCardCvv: false,
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
        ),
      ), */
    );
  }
}
